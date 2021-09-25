# frozen_string_literal: true

require './lib/challenge_constant'

module RobotChallenge
  ##
  # Robot class containing attributes and actions
  class Robot
    attr_reader :position_x, :position_y, :direction

    ##
    # @param position_x (String)
    # @param position_y (String)
    # @param direction (String)
    def initialize(position_x, position_y, direction)
      @position_x = position_x.to_i
      @position_y = position_y.to_i
      @direction = direction
    end

    ##
    # An ability of the robot to move on the board
    # Direction will always be valid
    def move
      case @direction
      when 'NORTH'
        @position_y += 1 if @position_y < MAX_DIMENSION[1]
      when 'WEST'
        @position_x -= 1 if @position_x > MIN_DIMENSION[0]
      when 'EAST'
        @position_x += 1 if @position_x < MAX_DIMENSION[0]
      when 'SOUTH'
        @position_y -= 1 if @position_y > MIN_DIMENSION[1]
      end
    end

    ##
    # An ability of the robot to turn on the board
    # turning direction will always be valid
    # @param turning_direction (String)
    # @return (String) error message if exists
    def turn(turning_direction)
      current_direction = DIRECTION.find_index(@direction)
      case turning_direction
      when 'LEFT'
        # Consider current direction as the last index of array if zero
        current_direction = current_direction.zero? ? DIRECTION.length : current_direction
        current_direction -= 1
      when 'RIGHT'
        # Consider current direction as the last index of array if zero
        current_direction = current_direction == DIRECTION.length - 1 ? 0 : current_direction
        current_direction += 1
      end
      @direction = DIRECTION[current_direction]
    end
  end
end
