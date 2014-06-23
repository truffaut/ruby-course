require_relative "../orm.rb"
class TM::Project
  attr_reader :name, :pid

  def initialize(params)
    @name = params[0]
    @pid = Integer(params[1])
  end

  # returns a single project entity by id
  def self.get(pid)
    TM::orm.project_get(pid)
  end

  # returns an array of project entities
  def self.list
    TM::orm.projects_list
  end
  # README:
  # returns the project just created
  def self.create(name)
    TM::orm.project_create(name)
  end

  # return an array of employees entities
  ##### participating in project
  def self.employees(pid)
    TM::orm.project_employees(pid)
  end

  # returns a hash of the project and employee entity just linked
  def self.recruit(pid, eid)
    TM::orm.project_recruit(pid, eid)
  end

  # COMPLETED
  # TODO: NEEDS CLASS TESTING
  # returns array of completed tasks
  def self.completed_tasks(pid)
    completed = TM::orm.project_history(pid)
    completed.sort {|a, b| a.creation_time <=> b.creation_time}
  end

  # COMPLETED
  # TODO: NEEDS CLASS TESTING
  # returns array of incompleted tasks
  def self.incomplete_tasks(pid)
    incomplete = TM::orm.project_show(pid)
    incomplete.sort {|a,b| (b.priority <=> a.priority) == 0 ? (a.creation_time <=> b.creation_time) : (b.priority <=> a.priority)}
  end
end
