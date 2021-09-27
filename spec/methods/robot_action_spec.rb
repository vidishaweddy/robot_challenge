# frozen_string_literal: true

require 'spec_helper'
require './lib/methods/robot_action'

RSpec.describe 'robot_action' do
  context 'execute' do
    it 'returns the current robot position' do
      movements = ['PLACE 0,0,NORTH', 'MOVE', 'LEFT']
      robot = RobotChallenge::RobotActionMethods.execute(movements, movements.length)
      expect(robot.current_position).to eq('0,1,WEST')
    end

    it 'returns the info message if robot action can cause robot to fall ' do
      movements = ['PLACE 0,0,SOUTH', 'MOVE', 'LEFT']
      expect do
        RobotChallenge::RobotActionMethods.execute(movements, movements.length)
      end.to output("Warning: Move action on line 2 is skipped to prevent robot from falling\n").to_stdout
      robot = RobotChallenge::RobotActionMethods.execute(movements, movements.length)
      expect(robot.current_position).to eq('0,0,EAST')
    end

    it 'returns the info message if robot action is unknown ' do
      movements = ['PLACE 0,0,EAST', 'MOVE', 'TURN']
      expect do
        RobotChallenge::RobotActionMethods.execute(movements, movements.length)
      end.to output("Warning: Action on line 3 is invalid. Action will be skipped\n").to_stdout
      robot = RobotChallenge::RobotActionMethods.execute(movements, movements.length)
      expect(robot.current_position).to eq('1,0,EAST')
    end
  end
end