# frozen_string_literal: true

require './lib/objects/robot'
require './lib/challenge_constant'
require './lib/methods/robot_validation'

module RobotChallenge
  # Run commands to determine robot movement
  module RobotActionMethods
    ##
    # Execute action based on input
    # @param movements (String[])
    # @param index (Integer)
    # @param robot (Robot)
    # @return Robot
    def self.execute(movements, index, robot = nil)
      index -= movements.length
      @robot = robot
      movements.each.with_index do |movement, i|
        if movement.include?('PLACE ')
          value = movement.gsub('PLACE ', '').split(',')
          @robot = RobotValidationMethods.placement_valid?(value, index + i) ? Robot.new(*value) : nil
        elsif @robot
          execute_movement(movement, index + i)
        end
      end

      @robot
    end

    private

    ##
    # Execute movement (MOVE, LEFT or RIGHT) based on input
    # @param movement (String)
    # @param index (Integer)
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
