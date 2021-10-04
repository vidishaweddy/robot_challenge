# frozen_string_literal: true

require './lib/objects/tabletop_item'

##
# Robot class derived from tabletop item with specific rules applied to robot
class Robot < TabletopItem
  def initialize
    # Safe to assume that negative position will never exist
    @position_x = -1
    @position_y = -1
    @direction = ''
    @errors = {}
    super
  end

  ##
  # A specific action of robot to turn left
  def left
    current_direction = DIRECTION.find_index(@direction)
    current_direction = current_direction.zero? ? DIRECTION.length : current_direction
    @direction = DIRECTION[current_direction - 1]
  end

  ##
  # A specific action of robot to turn right
  def right
    current_direction = DIRECTION.find_index(@direction)
    current_direction = current_direction == DIRECTION.length - 1 ? -1 : current_direction
    @direction = DIRECTION[current_direction + 1]
  end
end
