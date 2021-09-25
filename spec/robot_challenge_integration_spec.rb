require 'spec_helper'
require 'robot_challenge'

RSpec.describe 'integration' do
  describe RobotChallenge do
    it 'outputs the final robot position' do
      result = <<~TEXT
        Enter your commands:
        Output: 0,1,WEST
      TEXT
      input = File.open('spec/fixtures/valid_sample.txt').map(&:chomp)
      allow($stdin).to receive(:gets).and_return(*input, "REPORT\n")
      expect do
        RobotChallenge.call
      end.to output(result).to_stdout
    end

    it 'outputs the error if placement is invalid' do
      result = <<~TEXT
        Enter your commands:
        Error: You need to put a valid PLACE command
      TEXT
      input = File.open('spec/fixtures/invalid_placement_sample.txt').map(&:chomp)
      allow($stdin).to receive(:gets).and_return(*input, "REPORT\n")
      expect do
        RobotChallenge.call
      end.to output(result).to_stdout
    end

    it 'outputs the warning if input action is illegal' do
      result = <<~TEXT
        Enter your commands:
        Warning: Position on line 1 must be a valid number
        Warning: Action on line 3 causes robot to be placed outside the tabletop, \
        all other commands will be ignored until the next PLACE command
        Warning: Direction on line 5 is invalid
        Warning: Value on line 7 is invalid
        Warning: Move action on line 10 is skipped to prevent robot from falling
        Warning: Action on line 13 is invalid. Action will be skipped
        Output: 1,0,EAST
      TEXT
      input = File.open('spec/fixtures/valid_with_illegal_movement.txt').map(&:chomp)
      allow($stdin).to receive(:gets).and_return(*input, "REPORT\n")
      expect do
        RobotChallenge.call
      end.to output(result).to_stdout
    end

    context 'performance testing' do
      it 'performs under certain time constraint with final invalid placement' do
        input = File.open('spec/fixtures/performance_valid_sample_1.txt').map(&:chomp)
        allow($stdin).to receive(:gets).and_return(*input, "REPORT\n")
        expect do
          RobotChallenge.call
        end.to perform_under(1).ms

        allow($stdin).to receive(:gets).and_return(*input, "REPORT\n")
        expect do
          RobotChallenge.call
        end.to output(/Output: Robot is not on the tabletop/).to_stdout
      end

      it 'performs under certain time constraint with final valid placement' do
        input = File.open('spec/fixtures/performance_valid_sample_2.txt').map(&:chomp)
        allow($stdin).to receive(:gets).and_return(*input, "REPORT\n")
        expect do
          RobotChallenge.call
        end.to perform_under(1).ms

        allow($stdin).to receive(:gets).and_return(*input, "REPORT\n")
        expect do
          RobotChallenge.call
        end.to output(/Output: 1,0,EAST/).to_stdout
      end
    end
  end
end
