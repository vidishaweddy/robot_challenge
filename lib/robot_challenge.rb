# frozen_string_literal: true

require './lib/methods/robot_movement'
require './lib/methods/robot_validation'
##
# Robot App Main Module
module RobotChallenge
  ##
  # @return [String] Reporting last location of the robot
  #
  # A string informing the error will be added if robot is out of bound or move is invalid
  def self.call
    puts 'Welcome to Robot Challenge App. Please read the readme to learn how to use the app'
    puts 'Enter your commands:'
    inputs = []
    index = 0
    skip_input = true
    until (text = $stdin.gets) == "REPORT\n"
      skip_input = false if skip_input && text.to_s.include?('PLACE ') && check_input(text.to_s, index)
      inputs << text.chomp unless skip_input
      index += 1
    end
    puts (inputs.any? ? RobotMovementMethods.execute(inputs, index) : 'Error: You need to put a valid PLACE command')
  end

  private

  ##
  # Check if placement valid before storing it as a valid input
  # @param text (String) Input text
  # @param index (Integer) index
  # @return Boolean
  def self.check_input(text, index)
    value = text.chomp.gsub('PLACE ', '').split(',')
    RobotValidationMethods.placement_valid?(value, index)
  end
end
