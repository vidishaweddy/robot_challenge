require 'spec_helper'
require 'methods/robot_movement'

RSpec.describe 'robot_movement' do
  context 'execute' do
    it 'returns the current robot position' do
      movements = ['PLACE 0,0,NORTH', 'MOVE', 'LEFT']
      expect(RobotChallenge::RobotMovementMethods.execute(movements, movements.length)).to eq('Output: 0,1,WEST')
    end

    it 'returns the info message if robot action can cause robot to fall ' do
      movements = ['PLACE 0,0,SOUTH', 'MOVE', 'LEFT']
      expect do
        RobotChallenge::RobotMovementMethods.execute(movements, movements.length)
      end.to output("Warning: Move action on line 2 is skipped to prevent robot from falling\n").to_stdout
      expect(RobotChallenge::RobotMovementMethods.execute(movements, 0)).to eq('Output: 0,0,EAST')
    end

    it 'returns the info message if robot action is unknown ' do
      movements = ['PLACE 0,0,EAST', 'MOVE', 'TURN']
      expect do
        RobotChallenge::RobotMovementMethods.execute(movements, movements.length)
      end.to output("Warning: Action on line 3 is invalid. Action will be skipped\n").to_stdout
      expect(RobotChallenge::RobotMovementMethods.execute(movements, 0)).to eq('Output: 1,0,EAST')
    end
  end
end