# frozen_string_literal: true

require 'rspec-benchmark'
require 'simplecov'

SimpleCov.start
RSpec.configure do |config|
  config.example_status_persistence_file_path = 'spec/performance_result.txt'
  config.include RSpec::Benchmark::Matchers
end
