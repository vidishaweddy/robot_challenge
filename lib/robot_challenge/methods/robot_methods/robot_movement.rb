# frozen_string_literal: true

module RobotChallenge
  module Methods
    module RobotMethods
      # module containing specific movements that can be used by robot
      module RobotMovement
        ##
        # A specific action of robot to turn left
        def left
          current_direction = DIRECTION.find_index(@direction)
          current_direction = current_direction.zero? ? DIRECTION.length : current_direction
          self.direction = DIRECTION[current_direction - 1]
        end

        ##
        # A specific action of robot to turn right
        def right
          current_direction = DIRECTION.find_index(@direction)
          current_direction = current_direction == DIRECTION.length - 1 ? -1 : current_direction
          self.direction = DIRECTION[current_direction + 1]
        end

        ##
        # An ability of the self to move on the board
        # Direction will always be valid
        def move
          case direction
          when 'north'
            self.position_y += 1
          when 'west'
            self.position_x -= 1
          when 'east'
            self.position_x += 1
          when 'south'
            self.position_y -= 1
          end
        end
      end
    end
  end
end
