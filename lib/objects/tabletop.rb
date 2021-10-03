# frozen_string_literal: true

require 'dry-validation'
require './lib/objects/tabletop_item'

##
# Validator for table
class TabletopValidator < Dry::Validation::Contract
  params do
    required(:min_dimension).array(:integer)
    required(:max_dimension).array(:integer)
    optional(:item).filled(Dry::Types::Nominal.new(::TabletopItem).constructor(&:input))
  end

  rule(:item) do
    unless value.nil?
      key.failure('cannot be placed outside the tabletop. Action will be ignored') unless
        ((values[:min_dimension][0]..values[:max_dimension][0]).include?(value.position_x) &&
         (values[:min_dimension][1]..values[:max_dimension][1]).include?(value.position_y)) ||
        value.errors.any?

      key.failure(value.errors.join(', ')) if value.errors.any?
    end
  end
end

##
# Tabletop object to oversees objects placed on top of the table
class Tabletop
  attr_reader :item, :min_dimension, :max_dimension, :errors

  def initialize(object, min_dimension = [0, 0], max_dimension = [4, 4])
    validator = TabletopValidator.new
    validation_result = validator.call(min_dimension: min_dimension, max_dimension: max_dimension)
    raise "Error: Table top dimension is invalid. Details: #{validation_result.errors(full: true).map(&:text)}" unless
      validation_result.success?

    @errors = {}
    @item = object.new
    @min_dimension = min_dimension
    @max_dimension = max_dimension
  end

  ##
  # Update the current status of tabletop reflecting the changes made by the item
  # @param item (TabletopItem)
  def update_tabletop_status(item)
    validator = TabletopValidator.new
    validation_result = validator.call(max_dimension: @max_dimension, min_dimension: @min_dimension, item: item)
    if validation_result.success?
      @item = item
      @errors = {}
    else
      # Clear the data if the placement on the tabletop is invalid or item is invalid
      # using ID to determine a new placement (assume it's a different item)
      @item = @item.class.new if @item.id != item.id || item.errors.any?
      @errors = validation_result.errors(full: true).map(&:text)
    end
  end
end
