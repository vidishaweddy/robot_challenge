# frozen_string_literal: true

require './lib/robot_challenge/objects/tabletop'
require './lib/robot_challenge/objects/robot'
require './lib/robot_challenge/methods/robot_challenge_service'
require './lib/constant'

##
# Robot App Main Module
module RobotChallenge
  class << self
    ##
    # A method to execute robot actions based on inputs
    def call
      puts 'Welcome to Robot Challenge App. Please read the readme to learn how to use the app'
      puts 'Enter your commands:'
      tabletop = Objects::Tabletop.new(MIN_DIMENSION, MAX_DIMENSION)
      index = 0
      until (text = $stdin.gets.downcase.chomp) == 'exit'
        index += 1
        next if !tabletop.robot.placed? && !text.include?('place') && text.strip != 'report'

        run_command(text, tabletop, index)
      end
    end

    private

    def run_command(input, tabletop, index)
      if input.strip == 'report'
        report(tabletop)
      else
        Methods::RobotChallengeService.execute(sanitize_input(input.strip), tabletop, index)
      end
    end

    ##
    # Sanitize input received from the view/terminal before executing it
    # @param input (String)
    def sanitize_input(input)
      sanitized_input = input.scan(/^(\D+)(\s+|$)(.*)$/)
      sanitized_input.flatten.map(&:strip).reject(&:empty?)
    end

    ##
    # Report the current location of the robot
    # @param tabletop (Tabletop)
    def report(tabletop)
      puts "Output: #{tabletop.robot.current_position}"
      # clear the buffer
      $stdout.flush
    end
  end
end
