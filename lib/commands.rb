module TM

  class Commands

    #########################
    ##### TASK COMMANDS #####
    #########################

    ## DONE!
    def self.task_create(pid, priority, desc)
      begin
        task = TM::Task.create(pid, priority, desc)
        puts "TASK Successfully Added".green
        self.print_task_info(task)
      rescue Exception => e
        puts "Error Encountered During Task Creation".red
        puts e
        return
      end
    end

    def self.task_mark(tid)

    end

    def self.task_assign(tid, eid)

    end

    ############################
    ##### Project COMMANDS #####
    ############################

    # DONE
    def self.project_create(name)
      begin
        project = TM::Project.create(name)
        self.print_project_info(project)
      rescue Exception => e
        puts "Error Encountered During Project Creation"
        puts e
        return
      end
    end

    # DONE
    def self.project_list
      projects = TM::Project.list
      if !projects.empty?
        projects.each {|proj| self.print_project_info(proj)}
      else
        puts "You currently have no projects".yellow
      end
    end

    def self.project_recruit(pid, eid)

    end

    def self.project_employees(pid)

    end

    def self.project_history(pid)

    end

    def self.project_show(pid)
      begin
        tasks = TM::Project.incomplete_tasks(pid)
        binding.pry
        project = TM::Project.get(pid)
        if !tasks.empty?
          puts "Showing Incomplete Tasks for Project:".green
          self.print_project_info(project)
          tasks.each {|tsk| print_task_info(tsk)}
        elsif project == nil
          puts "Project ID Invalid".red
        else
          puts "No Tasks to list for Project".red
        end
      rescue Exception => e
        puts "Error Showing Project's Incomplete Tasks List".red
        puts e.backtrace
      end
    end

    #############################
    ##### EMPLOYEE COMMANDS #####
    #############################

    # DONE
    def self.emp_create(name)
      begin
        emp = TM::Employee.create(name)
        puts "Employee Created".green
        self.print_employee_info(emp)
      rescue Exception => e
        puts "Error Encountered During Project Creation".red
        puts e
        return
      end
    end

    # DONE
    def self.emp_list
      begin
        emps = TM::Employee.list
        if !emps.empty?
          emps.each {|emp| self.print_employee_info(emp)}
        else
          puts "No Employee's To List".yellow
        end
      rescue Exception => e
        puts "Error Listing Employees".red
        puts e
        return
      end
    end

    def self.emp_show

    end

    def self.emp_details

    end

    def self.emp_history

    end

    #########################
    ##### PRINT HELPERS #####
    #########################
    private
    def self.print_task_info(task)
      owner = task.owned_by_eid || "na"
      puts "TID: #{task.tid} | PID: #{task.pid} | OWNER: EID[#{owner}] | Priority: #{task.priority}".blue
      puts "Timestamp: #{task.creation_time} | Completed: #{task.complete}".blue
      puts "Description: #{task.desc}".light_blue
    end

    def self.print_project_info(proj)
      puts "PID: #{proj.pid} Name: #{proj.name}".light_blue
    end

    def self.print_employee_info(emp)
      puts "EID: #{emp.eid} Name: #{emp.name}".light_blue
    end
  end

end
