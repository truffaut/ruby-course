require_relative "../orm.rb"

class TM::Task

  attr_reader :pid, :desc, :priority, :creation_time, :complete, :tid, :owned_by_eid

  def initialize(params)
    @tid = Integer(params[0])
    @priority = Integer(params[1])
    @desc = params[2]
    @creation_time = Time.parse(params[3])
    @pid = Integer(params[4])
    params[5] == "f" ? @complete = false : @complete = true
    @owned_by_eid = params[6]
  end

  # RETURNS = a task entity
  def self.create(pid, priority, desc)
    TM.orm.task_create(pid, priority, desc)
  end

  # RETURNS = a hash with a TASK and EMPLOYEE entity
  def self.assign(tid, eid)
    TM.orm.task_assign(tid, eid)
  end

  # RETURNS the a TASK entity that was just marked completed
  def self.mark(tid)
    TM.orm.task_mark(tid)
  end

  def self.get(tid)
    TM.orm.task_get(tid)
  end

end
