require_relative "../orm.rb"

class TM::Task

  attr_reader :pid, :desc, :priority, :creation_time, :complete, :tid

  def initialize(tid, priority, desc, creation_time, pid, complete)
    @tid = Integer(tid)
    @pid = Integer(pid)
    @desc = desc
    @priority = Integer(priority)
    @creation_time = Time.new(creation_time)
    complete == "f" ? @complete = false : @complete = true
  end

  def mark_complete
    # TM::orm.task_mark(task_id)
  end

end
