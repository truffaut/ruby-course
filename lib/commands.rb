module TM

  class Commands

    def self.task_create(pid, priority, desc)
      begin
        task = TM::Task.create(pid, priority, desc)
      rescue Exception => e
        puts "Error Encounted During Task Creation".red
        puts e
        return
      end
      self.print_task_info(task)
    end

    def self.task_assign(tid, eid)
      begin
        results = TM::Task.assign(tid, eid)
      rescue Exception => e
        puts "Error Encounted During Task Creation".red
        purts e
        return
      end

    end

    def self.print_employee_info

    end

    def self.print_task_info(task)
      owner = task.owned_by_eid || "na"
      puts "TASK INFORMATION".green
      puts "TID: #{task.tid} | PID: #{task.pid} | OWNER: EID[#{owner}] | Priority: #{task.priority}".blue
      puts "Timestamp: #{task.creation_time} | Completed: #{task.complete}".blue
      puts "Description: #{task.desc}".light_blue
    end
  end

end
