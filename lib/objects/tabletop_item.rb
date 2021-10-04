# frozen_string_literal: true

require 'dry-validation'
require 'securerandom'

DIRECTION = %w[north east south west].freeze

##
# Validator for table object
class TabletopItemValidator < Dry::Validation::Contract
  params do
    required(:position_x).value(:integer, gteq?: 0)
    required(:position_y).value(:integer, gteq?: 0)
    required(:direction).filled(:string)
  end

  rule(:direction) do
    key.failure('is not a valid direction') unless DIRECTION.include?(value)
  end
end

##
# Abstract class for item placed on top of table
# Containing shared attributes and actions allowed for objects
class TabletopItem
  attr_reader :id, :position_x, :position_y, :direction, :errors

  def initialize
    return unless instance_of?(TabletopItem)

    raise 'Error: You are trying to instantiate an abstract class!'
  end

  def place(input)
    position_x, position_y, direction = input.split(',').map(&:strip)
    validator = TabletopItemValidator.new
    validation_result = validator.call(position_x: position_x, position_y: position_y, direction: direction)
    object = validation_result.to_h
    @position_x = object[:position_x]
    @position_y = object[:position_y]
    if validation_result.success?
      @direction = object[:direction]
      # To follow persisted object rule and to allow multiple items placement in the future
      @id = SecureRandom.uuid
    else
      @errors = validation_result.errors(full: true).map(&:text)
    end
  end

  ##
  # To check whether object is placed or not
  def placed?
    @position_x != -1 && @position_y != -1 && !@direction.chomp.empty?
  end

  ##
  # An ability of the object to move on the board
  # Direction will always be valid
  def move
    case @direction
    when 'north'
      @position_y += 1
    when 'west'
      @position_x -= 1
    when 'east'
      @position_x += 1
    when 'south'
      @position_y -= 1
    end
  end

  ##
  # Return current position of the object
  # @return String
  def current_position
    if placed?
      [@position_x, @position_y, @direction.upcase].join(',')
    else
      "#{self.class.name.to_s} is not on the tabletop"
    end
  end
end
