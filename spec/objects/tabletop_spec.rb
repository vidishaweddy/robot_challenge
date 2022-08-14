# frozen_string_literal: true

require './spec/spec_helper'
require './lib/robot_challenge/objects/tabletop'
require './lib/robot_challenge/objects/robot'

RSpec.describe 'tabletop' do
  before do
    @tabletop = RobotChallenge::Objects::Tabletop.new
  end

  context 'update_tabletop' do
    it 'updates the status of the tabletop based on current status of item' do
      robot = RobotChallenge::Objects::Robot.new
      robot.place('0,0,north')
      @tabletop.update_tabletop_status(robot)
      expect(@tabletop.robot.current_position).to eq('0,0,NORTH')
      @tabletop.robot.move
      expect(@tabletop.robot.current_position).to eq('0,1,NORTH')
    end

    it 'returns error if robot direction is invalid' do
      robot = RobotChallenge::Objects::Robot.new
      robot.place('0,0,center')
      @tabletop.update_tabletop_status(robot)
      expect(@tabletop.errors).to eq(['robot direction is not a valid direction'])
    end

    it 'returns error if robot location is outside the boundary' do
      robot = RobotChallenge::Objects::Robot.new
      robot.place('5,5,north')
      @tabletop.update_tabletop_status(robot)
      expect(@tabletop.errors).to eq(['robot cannot be placed outside the tabletop. Action will be ignored'])
    end

    it 'does not return error if robot location is inside the boundary' do
      robot = RobotChallenge::Objects::Robot.new
      robot.place('5,5,north')
      tabletop = RobotChallenge::Objects::Tabletop.new([0, 0], [5, 5])
      tabletop.update_tabletop_status(robot)
      expect(@tabletop.errors).to eq({})
    end

    it 'returns error if robot location value is invalid' do
      robot = RobotChallenge::Objects::Robot.new
      robot.place('5,5,north')
      expect do
        RobotChallenge::Objects::Tabletop.new([0, 0], [5, 5, 0])
      end.to raise_error(
        RuntimeError,
        'Error: Table top dimension is invalid. Details: ["max_dimension size cannot be greater than 2"]'
      )
    end
  end
end
