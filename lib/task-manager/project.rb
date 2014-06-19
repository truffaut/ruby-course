require_relative "../database.rb"
class TM::Project
  attr_reader :name, :pid, :project_tasks

  def initialize(name, pid)
    @name = name
    @pid = pid
  end

  def self.get_project(pid)
    # returns a single project entity by id
    TM::db.get_project(pid)
  end

  def self.get_projects
    # returns an array of project entities
    TM::db.list_projects
  end

  def add_task(desc, priority)
    new_task = TM::Task.new(@pid, desc, priority)
    @project_tasks << new_task
  end

  def completed_tasks
    completed = @project_tasks.select {|tsk| tsk.complete}
    completed.sort {|a, b| a.creation_time <=> b.creation_time}
  end

  def incomplete_tasks
    incomplete = @project_tasks.select {|tsk| !tsk.complete}
    incomplete.sort {|a,b| (b.priority <=> a.priority) == 0 ? (a.creation_time <=> b.creation_time) : (b.priority <=> a.priority)}
  end
end
