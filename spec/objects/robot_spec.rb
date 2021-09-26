# frozen_string_literal: true

require 'spec_helper'
require './lib/objects/robot'

RSpec.describe 'robot' do
  context 'move' do
    it 'moves based on robot current direction' do
      robot = RobotChallenge::Robot.new('0', '0', 'NORTH')
      robot.move
      expect(robot.position_x).to eq(0)
      expect(robot.position_y).to eq(1)

      robot = RobotChallenge::Robot.new('0', '0', 'EAST')
      robot.move
      expect(robot.position_x).to eq(1)
      expect(robot.position_y).to eq(0)

      robot = RobotChallenge::Robot.new('1', '1', 'SOUTH')
      robot.move
      expect(robot.position_x).to eq(1)
      expect(robot.position_y).to eq(0)

      robot = RobotChallenge::Robot.new('1', '1', 'WEST')
      robot.move
      expect(robot.position_x).to eq(0)
      expect(robot.position_y).to eq(1)

      # Direction is incorrect, so no movement
      robot = RobotChallenge::Robot.new('1', '1', 'CENTER')
      robot.move
      expect(robot.position_x).to eq(1)
      expect(robot.position_y).to eq(1)
    end

    it 'does not move if robot is at the edge of tabletop' do
      robot = RobotChallenge::Robot.new('0', '5', 'NORTH')
      robot.move
      expect(robot.position_x).to eq(0)
      expect(robot.position_y).to eq(5)

      robot = RobotChallenge::Robot.new('5', '0', 'EAST')
      robot.move
      expect(robot.position_x).to eq(5)
      expect(robot.position_y).to eq(0)

      robot = RobotChallenge::Robot.new('1', '0', 'SOUTH')
      robot.move
      expect(robot.position_x).to eq(1)
      expect(robot.position_y).to eq(0)

      robot = RobotChallenge::Robot.new('0', '1', 'WEST')
      robot.move
      expect(robot.position_x).to eq(0)
      expect(robot.position_y).to eq(1)
    end
  end

  context 'turn' do
    it 'turns based on input' do
      robot = RobotChallenge::Robot.new('0', '0', 'NORTH')
      robot.turn('LEFT')
      expect(robot.direction).to eq('WEST')

      robot2 = RobotChallenge::Robot.new('0', '0', 'NORTH')
      robot2.turn('RIGHT')
      expect(robot2.direction).to eq('EAST')
    end
  end
end
