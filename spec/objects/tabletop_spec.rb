# frozen_string_literal: true

require './spec/spec_helper'
require './lib/objects/tabletop'
require './lib/objects/robot'

RSpec.describe 'tabletop' do
  before do
    @tabletop = Tabletop.new(Robot)
  end

  context 'update_tabletop' do
    it 'updates the status of the tabletop based on current status of item' do
      robot = Robot.new
      robot.place('0,0,north')
      @tabletop.update_tabletop_status(robot)
      expect(@tabletop.item.current_position).to eq('0,0,NORTH')
      @tabletop.item.move
      expect(@tabletop.item.current_position).to eq('0,1,NORTH')
    end

    it 'returns error if robot direction is invalid' do
      robot = Robot.new
      robot.place('0,0,center')
      @tabletop.update_tabletop_status(robot)
      expect(@tabletop.errors).to eq(['item direction is not a valid direction'])
    end

    it 'returns error if robot location is outside the boundary' do
      robot = Robot.new
      robot.place('5,5,north')
      @tabletop.update_tabletop_status(robot)
      expect(@tabletop.errors).to eq(['item cannot be placed outside the tabletop. Action will be ignored'])
    end

    it 'does not return error if robot location is inside the boundary' do
      robot = Robot.new
      robot.place('5,5,north')
      tabletop = Tabletop.new(Robot, [0, 0], [5, 5])
      tabletop.update_tabletop_status(robot)
      expect(@tabletop.errors).to eq({})
    end

    it 'returns error if robot location value is invalid' do
      robot = Robot.new
      robot.place('5,5,north')
      expect do
        Tabletop.new(Robot, [0, 0], [5, 5, 0])
      end.to raise_error(
        RuntimeError,
        'Error: Table top dimension is invalid. Details: ["max_dimension size cannot be greater than 2"]'
      )
    end
  end
end
