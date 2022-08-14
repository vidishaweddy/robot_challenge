# frozen_string_literal: true

require 'dry-validation'
require 'securerandom'
require './lib/robot_challenge/methods/robot_methods/robot_movement'

module RobotChallenge
  module Objects
    ##
    # Validator for table object
    class RobotValidator < Dry::Validation::Contract
      params do
        required(:position_x).value(:integer, gteq?: 0)
        required(:position_y).value(:integer, gteq?: 0)
        required(:direction).filled(:string)
      end

      rule(:direction) do
        key.failure('is not a valid direction') unless DIRECTION.include?(value)
      end
    end

    ##
    # Robot class containing its attributes and available methods
    class Robot
      include ::RobotChallenge::Methods::RobotMethods::RobotMovement

      attr_reader :id, :errors
      attr_accessor :position_x, :position_y, :direction

      def initialize
        set_position(nil, nil, '')
      end

      def place(input)
        position_x, position_y, direction = input.split(',').map(&:strip)
        validation_result = validate_input(position_x, position_y, direction)
        if validation_result.success?
          object = validation_result.to_h
          set_position(object[:position_x], object[:position_y], object[:direction])
          @id = SecureRandom.hex
        else
          @errors = validation_result.errors(full: true).map(&:text)
        end
      end

      ##
      # To check whether object is placed or not
      def placed?
        @position_x != -1 && @position_y != -1 && !@direction.chomp.empty?
      end

      ##
      # Return current position of the object
      # @return String
      def current_position
        if placed?
          [@position_x, @position_y, @direction.upcase].join(',')
        else
          'Robot is not on the tabletop'
        end
      end

      private

      def validate_input(position_x, position_y, direction)
        validator = RobotValidator.new
        validator.call(position_x: position_x, position_y: position_y, direction: direction)
      end

      def set_position(position_x, position_y, direction)
        @position_x = position_x
        @position_y = position_y
        @direction = direction
      end
    end
  end
end
