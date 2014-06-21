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
  # employee 1 - 3 projects = pid1,pid2,pid3
  # employee 2 - 2 projects = pid3,pid4, pid5
  5.times { |i| TM::orm.project_create("Project #{i+1}")}
  2.times { |i| TM::orm.employee_create("Employee #{i+1}")}
end

def populate_tasks_projects_employees
  populate_projects_and_employees
  3.times {|i| TM::orm.task_create(1, i*2, "task #{i+1}")}
  # pid1 = 3 tasks, tid1,tid2,tid3
  5.times {|i| TM::orm.task_create(4, i*2, "task #{i+1}")}
  # pid4 = 5 tasks. tid4,5,6,7,8
end
