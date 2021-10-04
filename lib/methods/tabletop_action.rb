# frozen_string_literal: true

# Controller to run commands to determine tabletop_item movement
class TabletopActionMethods
  ##
  # Run command based on input
  # @param input (Array[String])
  # @param tabletop (Tabletop)
  # @param index (Action line number)
  def self.execute(input, tabletop, index)
    return unless input.any?

    # create a duplicate of tabletop_item to validate the input before storing it
    tabletop_item = tabletop.item.dup
    tabletop_item.send(*input)
    tabletop.update_tabletop_status(tabletop_item)
    check_error(tabletop)
  rescue NoMethodError => _e
    # Warn is a configurable method on ruby that can be disabled if user does not want to see any warnings
    # $stderr cannot be disabled and rubocop does not recommend using it
    warn "Warning: Unknown action '#{input.first}' for #{tabletop_item.class.name} on line #{index}"
  rescue ArgumentError => e
    warn "Warning: Input on line #{index} is invalid. Details: #{e}"
  end

  private

  ##
  # raise an error if any?
  # @param object (Robot|Tabletop)
  def self.check_error(object)
    raise ArgumentError, object.errors if object.errors.any?
  end
end
