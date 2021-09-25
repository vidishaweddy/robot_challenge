# frozen_string_literal: true

require './lib/objects/robot'
require './lib/challenge_constant'
require './lib/methods/robot_validation'

module RobotChallenge
  # Run commands to determine robot movement
  module RobotMovementMethods
    ##
    # Execute movement based on input
    # @param movements (String[])
    # @param index (Integer)
    # @return String
    def self.execute(movements, index)
      index -= movements.length
      movements.each.with_index do |movement, i|
        if movement.include?('PLACE ')
          value = movement.gsub('PLACE ', '').split(',')
          @robot = if RobotValidationMethods.placement_valid?(value, index + i)
                     Robot.new(*value)
                   end

        elsif @robot
          execute_movement(movement, index + i)
        end
      end

      output = @robot ? "#{@robot.position_x},#{@robot.position_y},#{@robot.direction}" : 'Robot is not on the tabletop'
      "Output: #{output}"
    end

    private

    def self.execute_movement(movement, index)
      current_robot = @robot.dup
      if movement == 'MOVE'
        @robot.move
        puts "Warning: Move action on line #{index + 1} is skipped to prevent robot from falling" if
          current_robot.position_x == @robot.position_x && current_robot.position_y == @robot.position_y
      elsif CHANGE_DIRECTION.include?(movement)
        @robot.turn(movement)
      else
        puts "Warning: Action on line #{index + 1} is invalid. Action will be skipped"
      end
    end
  end
end
