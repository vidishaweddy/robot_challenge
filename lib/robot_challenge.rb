# frozen_string_literal: true

require './lib/methods/robot_action'
require './lib/methods/robot_validation'
##
# Robot App Main Module
module RobotChallenge
  ##
  # A method to execute robot actions based on inputs
  def self.call
    puts 'Welcome to Robot Challenge App. Please read the readme to learn how to use the app'
    puts 'Enter your commands:'
    data_inputs = []
    index = 0
    skip_input = true
    until (text = $stdin.gets.upcase) == "EXIT\n"
      skip_input = false if skip_input && text.to_s.include?('PLACE ') && check_input(text.to_s, index)
      data_inputs = process_input(text, data_inputs, index, skip_input)
      index += 1
    end
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

  ##
  # process input
  # @param text (String) Input text
  # @param inputs (String[])
  # @param index (Integer)
  # @param skip_input (Boolean)
  # @return Array
  def self.process_input(text, inputs, index, skip_input)
    if text.chomp.to_s == 'REPORT'
      report(inputs, index)
    elsif !skip_input
      return inputs + [text.chomp]
    end
    []
  end

  ##
  # Report the current location of the robot
  # @param inputs (String[])
  # @param index (Integer)
  # @return String
  def self.report(inputs, index)
    puts (if inputs.any?
            @robot = RobotActionMethods.execute(inputs, index, @robot)
            "Output: #{@robot ? @robot.current_position : 'Robot is not on the tabletop'}"
          else
            'Error: You need to put a valid PLACE command'
          end)
  end
end
