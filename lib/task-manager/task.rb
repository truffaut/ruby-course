require_relative "../orm.rb"

class TM::Task

  attr_reader :pid, :desc, :priority, :creation_time, :complete, :tid, :owned_by_eid

  def initialize(params)
    # tid,      priority,   desc,   creation_time, pid,     complete     owned_by_id)
    # params[1], params[1], params[2], params[3], params[4], params[5], params[6]
    @tid = Integer(params[0])
    @priority = Integer(params[1])
    @desc = params[2]
    @creation_time = Time.parse(params[3])
    @pid = Integer(params[4])
    params[5] == "f" ? @complete = false : @complete = true
    @owned_by_eid = params[6]
  end

  # TODO: Implement the mark_completed method within the class
  def self.mark_complete(task_id)
    # TM::orm.task_mark(task_id)
  end

end
