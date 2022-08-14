# frozen_string_literal: true

module RobotChallenge
  module Methods
    # Controller to run commands to determine robot movement
    class RobotChallengeService
      class << self
        ##
        # Run command based on input
        # @param input (Array[String]). contain max 2 items, action and params
        # @param tabletop (Tabletop)
        # @param index (Action line number)
        def execute(input, tabletop, index)
          return unless input.any?

          # create a duplicate of robot to validate the input before storing it
          @robot = tabletop.robot.dup
          move_robot(index, *input)
          tabletop.update_tabletop_status(@robot)
          check_error(tabletop)
        rescue StandardError => e
          warn "Warning: Input on line #{index} is invalid. Details: #{e}"
        end

        private

        ##
        # Use case to make sure action is correct. Can use meta programming but less readable and more prone to error
        def move_robot(index, action, params = nil)
          case action
          when 'left'
            @robot.left
          when 'right'
            @robot.right
          when 'move'
            @robot.move
          when 'place'
            @robot.place(params)
          else
            warn "Warning: Input on line #{index} is invalid. Action #{action} is unknown"
          end
        end

        ##
        # raise an error if any?
        # @param object (Robot|Tabletop)
        def check_error(object)
          raise ArgumentError, object.errors if object.errors.any?
        end
      end
    end
  end
end
