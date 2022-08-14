# frozen_string_literal: true

require 'dry-validation'
require './lib/robot_challenge/objects/robot'

module RobotChallenge
  module Objects
    ##
    # Validator for table
    class TabletopValidator < Dry::Validation::Contract
      params do
        required(:min_dimension).filled(:array, min_size?: 2, max_size?: 2).each(:integer)
        required(:max_dimension).filled(:array, min_size?: 2, max_size?: 2).each(:integer)
        optional(:robot).filled(Dry::Types::Nominal.new(Robot).constructor(&:input))
      end

      rule(:robot) do
        unless value.nil?
          key.failure('cannot be placed outside the tabletop. Action will be ignored') unless
            ((values[:min_dimension][0]..values[:max_dimension][0]).include?(value.position_x) &&
            (values[:min_dimension][1]..values[:max_dimension][1]).include?(value.position_y)) ||
            value.errors&.any?

          key.failure(value.errors.join(', ')) if value.errors&.any?
        end
      end
    end

    ##
    # Tabletop object to oversees robots placed on top of the table
    class Tabletop
      attr_reader :robot, :min_dimension, :max_dimension, :errors

      def initialize(min_dimension = [0, 0], max_dimension = [4, 4])
        validation_result = validate_input(min_dimension, max_dimension)
        unless validation_result.success?
          raise "Error: Table top dimension is invalid. Details: #{validation_result.errors(full: true).map(&:text)}"
        end

        @errors = {}
        @robot = Robot.new
        @min_dimension = min_dimension
        @max_dimension = max_dimension
      end

      ##
      # Update the current status of tabletop reflecting the changes made by the robot
      # @param robot (Robot)
      def update_tabletop_status(robot)
        validator = TabletopValidator.new
        validation_result = validator.call(max_dimension: @max_dimension, min_dimension: @min_dimension, robot: robot)
        if validation_result.success?
          @robot = robot
          @errors = {}
        else
          # Clear the data if the placement on the tabletop is invalid or robot is invalid
          @robot = @robot.class.new if robot.errors&.any?
          @errors = validation_result.errors(full: true).map(&:text)
        end
      end

      private

      def validate_input(min_dimension, max_dimension)
        validator = TabletopValidator.new
        validator.call(min_dimension: min_dimension, max_dimension: max_dimension)
      end
    end
  end
end
