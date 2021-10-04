# frozen_string_literal: true

require './lib/objects/tabletop'
require './lib/objects/robot'
require './lib/methods/tabletop_action'
##
# Robot App Main Module
class RobotChallenge
  ##
  # A method to execute robot actions based on inputs
  # @param Item(Robot) the tabletop item you want to test
  def self.call(item = Robot)
    puts 'Welcome to Robot Challenge App. Please read the readme to learn how to use the app'
    puts 'Enter your commands:'
    tabletop = Tabletop.new(item)
    index = 0
    until (text = $stdin.gets.downcase.chomp) == 'exit'
      index += 1
      next if !tabletop.item.placed? && !text.include?('place') && text.strip != 'report'

      if text.strip == 'report'
        report(tabletop)
      else
        TabletopActionMethods.execute(sanitize_input(text.strip), tabletop, index)
      end
    end
  end

  ##
  # Sanitize input received from the view/terminal before executing it
  # @param input (String)
  def self.sanitize_input(input)
    sanitized_input = input.scan(/^(\D+)(\s+|$)(.*)$/)
    sanitized_input.flatten.map(&:strip).reject(&:empty?)
  end

  ##
  # Report the current location of the robot
  # @param tabletop (Tabletop)
  def self.report(tabletop)
    puts "Output: #{tabletop.item.current_position}"
    # clear the buffer
    $stdout.flush
  end
end
