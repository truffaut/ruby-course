# Require our project, which in turns requires everything else
require './lib/task-manager.rb'
require 'rspec/mocks'

RSpec.configure do |config|
  # Configure each test to always use a new singleton instance
  config.before(:each) do
    DBI.instance_variable_set(:@__db_instance, nil)
  end
end
