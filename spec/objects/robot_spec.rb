# frozen_string_literal: true

require './spec/spec_helper'
require './lib/robot_challenge/objects/robot'

RSpec.describe 'robot' do
  context 'place' do
    it 'places the robot' do
      robot = RobotChallenge::Objects::Robot.new
      robot.place('0, 0, north')
      expect(robot.position_x).to eq(0)
      expect(robot.position_y).to eq(0)
      expect(robot.direction).to eq('north')
    end

    it 'returns an error if robot is placed on unknown direction' do
      robot = RobotChallenge::Objects::Robot.new
      robot.place('0, 0, center')
      expect(robot.errors).to eq(['direction is not a valid direction'])
    end

    it 'returns an error if robot is placed negative position' do
      robot = RobotChallenge::Objects::Robot.new
      robot.place('-1, 0, north')
      expect(robot.errors).to eq(['position_x must be greater than or equal to 0'])
    end
  end

  context 'move' do
    it 'moves based on robot current direction' do
      robot = RobotChallenge::Objects::Robot.new
      robot.place('0, 0, north')
      robot.move
      expect(robot.position_x).to eq(0)
      expect(robot.position_y).to eq(1)

      robot = RobotChallenge::Objects::Robot.new
      robot.place('0, 0, east')
      robot.move
      expect(robot.position_x).to eq(1)
      expect(robot.position_y).to eq(0)

      robot = RobotChallenge::Objects::Robot.new
      robot.place('1, 1, south')
      robot.move
      expect(robot.position_x).to eq(1)
      expect(robot.position_y).to eq(0)

      robot = RobotChallenge::Objects::Robot.new
      robot.place('1, 1, west')
      robot.move
      expect(robot.position_x).to eq(0)
      expect(robot.position_y).to eq(1)
    end
  end

  context 'turn' do
    it 'turns based on input' do
      robot = RobotChallenge::Objects::Robot.new
      robot.place('0,0,north')
      robot.left
      expect(robot.direction).to eq('west')
      robot.left
      expect(robot.direction).to eq('south')
      robot.left
      expect(robot.direction).to eq('east')
      robot.left
      expect(robot.direction).to eq('north')

      robot2 = RobotChallenge::Objects::Robot.new
      robot2.place('0,0,north')
      robot2.right
      expect(robot2.direction).to eq('east')
      robot2.right
      expect(robot2.direction).to eq('south')
      robot2.right
      expect(robot2.direction).to eq('west')
      robot2.right
      expect(robot2.direction).to eq('north')
    end
  end

  context 'current_position' do
    it 'returns a string of robot\'s current position on tabletop' do
      robot = RobotChallenge::Objects::Robot.new
      robot.place('0,0,north')
      expect(robot.current_position).to eq('0,0,NORTH')

      robot = RobotChallenge::Objects::Robot.new
      robot.place('0,0,center')
      expect(robot.current_position).to eq('Robot is not on the tabletop')

      robot = RobotChallenge::Objects::Robot.new
      robot.place('-1,-1,north')
      expect(robot.current_position).to eq('Robot is not on the tabletop')
    end
  end
end
