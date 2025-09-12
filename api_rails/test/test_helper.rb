# SimpleCov must be started before any application code is loaded
require "simplecov"

SimpleCov.start "rails" do
  add_filter "/test/"
  add_filter "/vendor/"
  
  track_files "app/**/*.rb"
  track_files "lib/**/*.rb"
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Add more helper methods to be used by all tests here...
  end
end
