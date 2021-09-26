# frozen_string_literal: true

require 'spec_helper'
require './lib/methods/robot_validation'

RSpec.describe 'robot_validation' do
  context 'placement_valid?' do
    it 'returns true if place command is valid' do
      movement = %w[0 0 NORTH]
      expect(RobotChallenge::RobotValidationMethods.placement_valid?(movement, 0)).to eq(true)
    end

    it 'returns warning message if place command is invalid ' do
      movement = %w[0 0]
      expect do
        RobotChallenge::RobotValidationMethods.placement_valid?(movement, 0)
      end.to output("Warning: Value on line 1 is invalid\n").to_stdout
      expect(RobotChallenge::RobotValidationMethods.placement_valid?(movement, 0)).to eq(false)
    end

    it 'returns warning message if place position is not a number' do
      movement = %w[0 A NORTH]
      expect do
        RobotChallenge::RobotValidationMethods.placement_valid?(movement, 0)
      end.to output("Warning: Position on line 1 must be a valid number\n").to_stdout
      expect(RobotChallenge::RobotValidationMethods.placement_valid?(movement, 0)).to eq(false)
    end

    it 'returns warning message if place position is outside the tabletop' do
      movement = %w[0 6 NORTH]
      expect do
        RobotChallenge::RobotValidationMethods.placement_valid?(movement, 0)
      end.to output('Warning: Action on line 1 causes robot to be placed outside the tabletop, '\
                    "all other commands will be ignored until the next PLACE command\n").to_stdout
      expect(RobotChallenge::RobotValidationMethods.placement_valid?(movement, 0)).to eq(false)
    end

    it 'returns warning message if robot direction is invalid' do
      movement = %w[0 0 CENTER]
      expect do
        RobotChallenge::RobotValidationMethods.placement_valid?(movement, 0)
      end.to output("Warning: Direction on line 1 is invalid\n").to_stdout
      expect(RobotChallenge::RobotValidationMethods.placement_valid?(movement, 0)).to eq(false)
    end
  end
end
