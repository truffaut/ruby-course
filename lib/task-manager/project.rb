require_relative "../orm.rb"
class TM::Project
  attr_reader :name, :pid

  def initialize(params)
    # name,     pid
    # params[0], params[1]
    @name = params[0]
    @pid = Integer(params[1])
  end

  # returns a single project entity by id
  def self.get_project(pid)
    TM::db.get_project(pid)
  end

  # returns an array of project entities
  def self.get_projects
    TM::db.list_projects
  end

  #TODO: Implement the add task feature within the project
  # this might not be necessary any longer
  # def add_task(desc, priority)
  #   new_task = TM::Task.new(@pid, desc, priority)
  #   @project_tasks << new_task
  # end

  # TODO: Implement the completed_task method using the new ORM helpers
  # THE ORM does not sort the results so they still need to be sorted
  def completed_tasks
    # completed = @project_tasks.select {|tsk| tsk.complete}
    # completed.sort {|a, b| a.creation_time <=> b.creation_time}
  end

  # TODO: Implement the imcomplete_task method using the new ORM helpers
  # THE ORM does not sort the results so they still need to be sorted
  def incomplete_tasks
    incomplete = @project_tasks.select {|tsk| !tsk.complete}
    incomplete.sort {|a,b| (b.priority <=> a.priority) == 0 ? (a.creation_time <=> b.creation_time) : (b.priority <=> a.priority)}
  end
end
