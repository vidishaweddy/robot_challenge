# frozen_string_literal: true

task default: [:run]

desc 'load the methods'
task 'run' do
  $LOAD_PATH.unshift(File.dirname(__FILE__), 'lib')
  require 'lib/robot_challenge'

  # call the app
  RobotChallenge.call
end
