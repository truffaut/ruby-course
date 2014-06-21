# Require our project, which in turns requires everything else
require './lib/task-manager.rb'
require 'rspec/mocks'

def are_tasks_equal(t1, t2)
  t1.priority == t2.priority &&
    t1.pid == t2.pid &&
    t1.creation_time == t2.creation_time &&
    t1.complete == t2.complete &&
    t1.desc == t2.desc &&
    t1.tid == t2.tid
end

# This is for internal testing purposes as well as rspec tests
def populate_projects_and_employees
  5.times { |i| TM::orm.project_create("Project #{i+1}")}
  2.times { |i| TM::orm.employee_create("Employee #{i+1}")}
  3.times { |i| TM::orm.project_recruit(i+1, 1)}
  2.times { |i| TM::orm.project_recruit(i+3, 2)}
end
