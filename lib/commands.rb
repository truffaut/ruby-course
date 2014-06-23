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

    # DONE
    def self.task_mark(tid)
      begin
        task = TM::Task.mark(tid)
        if task != nil
          puts "Task has been been marked completed!".green
          self.print_task_info(task)
        else
          puts "Task could not be found".yellow
        end
      rescue Exception => e
        puts "Error Marking Task Completed".red
        puts e
      end
    end

    # DONE
    def self.task_assign(tid, eid)
      begin
        results = TM::Task.assign(tid, eid)
        if results == nil
          puts "Both EID and TID are invalid invalid".yellow
        elsif results[:employee] == nil
          puts "employee ID is invalid".yellow
          return
        elsif results[:task] == nil
          puts "employee ID is invalid".yellow
          return
        else
          puts "Task Assignment Successful Results Below".green
          print_employee_info(results[:employee])
          print_task_info(results[:task])
        end
      rescue Exception => e
        puts "Error assinging task to employee".red
        puts e.inspect
        return
      end
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

    # DONE
    def self.project_recruit(pid, eid)
      begin
        results = TM::Project.recruit(pid, eid)
        puts "Employee Successfully Recruited for Project"
        self.print_project_info(results[:project])
        self.print_employee_info(results[:employee])
      rescue Exception => e
        puts "Error Recruiting Employee for Project".red
        puts e.inspect
        return
      end
    end

    # DONE
    def self.project_employees(pid)
      begin
        emps = TM::Project.employees(pid)
        raise "No Employee's Involved in Project" if emps.empty?
        proj = TM::Project.get(pid)
        puts "Listing Employee's Involved in Project".green
        self.print_project_info(proj)
        emps.each { |emp| self.print_employee_info(emp)}
      rescue Exception => e
        puts "Error Listing Employee's Involved in Project".red
        puts e.inspect
        return
      end
    end

    # DONE
    def self.project_history(pid)
      begin
        tasks = TM::Project.completed_tasks(pid)
        project = TM::Project.get(pid)
        if !tasks.empty?
          puts "Showing Completed Tasks for Project:".green
          self.print_project_info(project)
          tasks.each {|tsk| print_task_info(tsk)}
        elsif project == nil
          puts "Project ID Invalid".red
        else
          puts "No Tasks to list for Project".red
        end
      rescue Exception => e
        puts "Error Showing Project's Completed Tasks List".red
        puts e.inspect
      end
    end

    # DONE
    def self.project_show(pid)
      begin
        tasks = TM::Project.incomplete_tasks(pid)
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
        puts e.inspect
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

    # DONE
    def self.emp_show(eid)
      projects = TM::Employee.show(eid)
      employee = TM::Employee.get(eid)
      puts "Showing Employee Projects".green
      self.print_employee_info(employee)
      projects.each {|proj| self.print_project_info(proj)}
    end

    def self.emp_details
      # TODO
    end

    def self.emp_history(eid)
      tasks = TM::Employee.history(eid)
      emp = TM::Employee.get(eid)
      puts "Completed Tasks for Employee".green
      self.print_employee_info(emp)
      tasks.each {|tsk| self.print_task_info(tsk)}
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
