# frozen_string_literal: true

require 'spec_helper'
require './lib/robot_challenge'

RSpec.describe 'integration' do
  before do
    @orig_stderr = $stderr
    $stderr = StringIO.new
  end

  describe RobotChallenge do
    it 'outputs the final robot position' do
      result = <<~TEXT
        Welcome to Robot Challenge App. Please read the readme to learn how to use the app
        Enter your commands:
        Output: 0,1,WEST
      TEXT
      input = File.open('spec/fixtures/valid_sample.txt').map(&:chomp)
      allow($stdin).to receive(:gets).and_return(*input, "exit\n")
      expect do
        RobotChallenge.call
      end.to output(result).to_stdout
    end

    it 'outputs the error if placement is invalid' do
      result = <<~TEXT
        Welcome to Robot Challenge App. Please read the readme to learn how to use the app
        Enter your commands:
        Output: Robot is not on the tabletop
      TEXT
      input = File.open('spec/fixtures/invalid_placement_sample.txt').map(&:chomp)
      allow($stdin).to receive(:gets).and_return(*input, "exit\n")
      expect do
        RobotChallenge.call
      end.to output(result).to_stdout
    end

    it 'outputs the warning if input action is illegal' do
      result = <<~TEXT
        Welcome to Robot Challenge App. Please read the readme to learn how to use the app
        Enter your commands:
        Output: 1,0,EAST
      TEXT

      warning = <<~TEXT
        Warning: Input on line 1 is invalid. Details: ["item position_y must be an integer"]
        Warning: Input on line 3 is invalid. Details: ["item cannot be placed outside the tabletop. Action will be ignored"]
        Warning: Input on line 5 is invalid. Details: ["item direction is not a valid direction"]
        Warning: Input on line 7 is invalid. Details: ["item position_y must be an integer, direction must be filled"]
        Warning: Input on line 10 is invalid. Details: ["item cannot be placed outside the tabletop. Action will be ignored"]
        Warning: Unknown action 'center' for Robot on line 13
      TEXT

      input = File.open('spec/fixtures/valid_with_illegal_movement.txt').map(&:chomp)
      allow($stdin).to receive(:gets).and_return(*input, "exit\n")
      expect do
        RobotChallenge.call
      end.to output(result).to_stdout

      $stderr.rewind
      expect($stderr.string).to eq(warning)
    end

    context 'performance testing' do
      it 'performs under certain time constraint with final invalid placement' do
        input = File.open('spec/fixtures/performance_valid_sample_1.txt').map(&:chomp)
        allow($stdin).to receive(:gets).and_return(*input, "exit\n")
        expect do
          RobotChallenge.call
        end.to perform_under(1).ms

        allow($stdin).to receive(:gets).and_return(*input, "exit\n")
        expect do
          RobotChallenge.call
        end.to output(/Output: Robot is not on the tabletop/).to_stdout
      end

      it 'performs under certain time constraint with final valid placement' do
        input = File.open('spec/fixtures/performance_valid_sample_2.txt').map(&:chomp)
        allow($stdin).to receive(:gets).and_return(*input, "exit\n")
        expect do
          RobotChallenge.call
        end.to perform_under(1).ms

        allow($stdin).to receive(:gets).and_return(*input, "exit\n")
        expect do
          RobotChallenge.call
        end.to output(/Output: 2,1,NORTH/).to_stdout
      end
    end
  end

  after do
    $stderr = @orig_stderr
  end
end
