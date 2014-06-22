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

  def self.create(name)
    TM::orm.project_create(name)
  end

  def self.employees(pid)

  end

  def self.recruit(pid, eid)

  end


  # TODO: Implement the completed_task method using the new ORM helpers
  # THE ORM does not sort the results so they still need to be sorted
  def self.completed_tasks(pid)
    # FIXME: REQUIRED TASK MARK TO BE COMPLETED
    completed = TM::orm.projects_history(pid)
    completed.sort {|a, b| a.creation_time <=> b.creation_time}
  end

  # Implement the imcomplete_task method using the new ORM helpers
  # THE ORM does not sort the results so they still need to be sorted
  def self.incomplete_tasks(pid)
    incomplete = TM::orm.project_show(pid)
    incomplete.sort {|a,b| (b.priority <=> a.priority) == 0 ? (a.creation_time <=> b.creation_time) : (b.priority <=> a.priority)}
  end
end
