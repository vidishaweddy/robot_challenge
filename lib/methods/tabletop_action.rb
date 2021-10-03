# frozen_string_literal: true

# Controller to run commands to determine robot movement
class TabletopActionMethods
  ##
  # Run command based on input
  # @param input (Array[String])
  # @param tabletop (Tabletop)
  # @param index (Action line number)
  def self.execute(input, tabletop, index)
    return unless input.any?

    # create a duplicate of robot to validate the input before storing it
    robot = tabletop.item.dup
    robot.send(*input)
    tabletop.update_tabletop_status(robot)
    check_error(tabletop)
  rescue NoMethodError => _e
    # Warn is a configurable method on ruby that can be disabled if user does not want to see any warnings
    # $stderr cannot be disabled and rubocop does not recommend using it
    warn "Warning: Unknown action on line #{index}"
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
