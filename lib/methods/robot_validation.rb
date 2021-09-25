# frozen_string_literal: true

require './lib/challenge_constant'

module RobotChallenge
  # Validation list for inputs
  module RobotValidationMethods
    ##
    # Placing robot on the tabletop
    # @param value (String)
    # @return Boolean
    def self.placement_valid?(value, index)
      value_valid?(value, index) &&
        position_number?(value[0], value[1], index) &&
        position_valid?(value[0], value[1], index) &&
        direction_valid?(value[2], index)
    end

    private

    ##
    # Validate input validity
    # @param value (String)
    # @return Boolean
    def self.value_valid?(value, index)
      if value.length != 3
        puts "Warning: Value on line #{index + 1} is invalid"
        return false
      end
      true
    end

    ##
    # Validate position of input
    # @param position_x (String)
    # @param position_y (String)
    # @return Boolean
    def self.position_valid?(position_x, position_y, index)
      unless (MIN_DIMENSION[0]..MAX_DIMENSION[0]).include?(position_x.to_i) &&
        (MIN_DIMENSION[1]..MAX_DIMENSION[1]).include?(position_y.to_i)
        puts "Warning: Action on line #{index + 1} causes robot to be placed outside the tabletop, "\
             'all other commands will be ignored until the next PLACE command'
        return false
      end
      true
    end

    ##
    # Validate position is
    # @param position_x (String)
    # @param position_y (String)
    # @return Boolean
    def self.position_number?(position_x, position_y, index)
      unless position_x.match?(/[0-9]/) && position_y.match?(/[0-9]/)
        puts "Warning: Position on line #{index + 1} must be a valid number"
        return false
      end
      true
    end

    ##
    # Validate direction of input
    # @param direction (String)
    # @return Boolean
    def self.direction_valid?(direction, index)
      unless DIRECTION.include?(direction)
        puts "Warning: Direction on line #{index + 1} is invalid"
        return false
      end
      true
    end
  end
end