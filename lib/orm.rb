require 'pg'
require 'pry-byebug'
require 'colorize'
module TM

  class ORM

    attr_reader :db_adapter

    def initialize
      @db_adapter = PG.connect({host: 'localhost', dbname: 'task-manager'})
      @test = false;
    end

###########################################################################
########################### Employees Model Methods #######################
###########################################################################

    # REQUIRED, TESTED
    # COMMAND
    # List all employees
    ##### RETURNS - an array of employee entities
    def employees_list()
      command = <<-SQL
        SELECT * FROM employees;
      SQL
      results = @db_adapter.exec(command).values
      results.map {|employee| TM::Employee.new(employee)}
    end

    # REQUIRED, TESTED
    # COMMAND
    # Create a new employee
    ##### DATABASE - addes employee to database
    ##### RETURNS - a employee entity
    def employee_create(name)
      command = <<-SQL
        INSERT INTO employees (name)
        VALUES('#{name}');
      SQL
      @db_adapter.exec(command)
      employee_info = @db_adapter.exec("SELECT * FROM employees ORDER BY id DESC LIMIT 1").values.flatten
      Employee.new(employee_info)
    end

    # REQUIRED, TESTED
    # COMMAND
    # Show employee EID and all participating projects
    ##### RETURNS - an array of projects
    def employee_show_projects(employee_id)
      command = <<-SQL
        SELECT proj_id
        FROM employees_projects
        WHERE employee_id = '#{employee_id}';
      SQL
      # return a list of project id's
      results = @db_adapter.exec(command).values.flatten
      results.map { |pid| project_get(pid)}
    end

    # REQUIRED
    # COMMAND, TODO
    # Show all remaining tasks assigned to employee EID,
    # along with the project name next to each task
    def employee_details(employee_id)
      # REQUIRES TASK ASSIGN
    end

    # REQUIRED
    # COMMAND, TODO
    # Show completed tasks for employee
    def employee_history(employee_id)
      # REQUIRES task assign
    end

    # TODO: testing
    def employee_get(eid)
      command = <<-SQL
        SELECT * FROM employees WHERE id='#{eid}'
      SQL
      results = @db_adapter.exec(command).values.flatten
      # returns a single project entity specified by ID
      TM::Employee.new(results)
    end
###########################################################################
########################## Projects Model Methods #########################
###########################################################################

    # REQUIRED, TESTED
    # COMMAND
    # List all projects
    ##### RETURNS - a array of project entities
    def projects_list
      command = <<-SQL
        SELECT * FROM projects;
      SQL
      results = @db_adapter.exec(command).values.flatten
      results.map {|proj| TM::Project.new(results)}
    end

    # REQUIRED, TESTED
    # COMMAND
    # Create a new project
    ##### DATABASE - adds project to database
    ##### RETURNS - a project entity
    def project_create(name)
      command = <<-SQL
        INSERT INTO projects (name)
        VALUES('#{name}');
      SQL
      @db_adapter.exec(command)
      proj = @db_adapter.exec("SELECT * FROM projects ORDER BY id DESC LIMIT 1").values.flatten
      TM::Project.new(proj)
    end

    # REQUIRED, TESTED
    # COMMAND
    # Show remaining tasks for project PID, completed = 'f'
    ##### RETURNS - an array of TASK entities
    def project_show(proj_id)
      command = <<-SQL
        SELECT * FROM tasks
        WHERE proj_id='#{proj_id}'
        AND completed='f';
      SQL
      results = @db_adapter.exec(command).values
      results.map {|proj| TM::Task.new(proj)}
    end

    # REQUIRED, TESTED
    # COMMAND
    # Show completed tasks for project PID
    ##### RETURNS - an array of TASK entities
    def project_history(proj_id)
      command = <<-SQL
        SELECT * FROM tasks
        WHERE proj_id='#{proj_id}'
        AND completed='t';
      SQL
      results = @db_adapter.exec(command).values
      results.map {|proj| TM::Task.new(proj)}
    end

    # REQUIRED, TESTED
    # COMMAND
    # Show employees participating in this project
    ##### RETURNS - an array of EMPLOYEE entities
    def project_employees(proj_id)
      # command returns a list of employee_ids
      # involved in the specific projcet
      command = <<-SQL
        SELECT employee_id
        FROM employees e
        JOIN employees_projects ep
        ON e.id = ep.employee_id
        WHERE proj_id='#{proj_id}';
      SQL
      results = @db_adapter.exec(command).values.flatten
      results.map { |eid| employee_get(eid)}
    end

    # REQUIRED, TESTED
    # COMMAND
    # Adds employee EID to participate in project PID
    ##### RETURNS - a hash of the PROJECT entity and EMPLOYEE entity
    def project_recruit(pid, eid)
      # this links a employee id with
      # a project id in the join table
      command = <<-SQL
        INSERT INTO employees_projects (proj_id, employee_id)
        VALUES('#{pid}','#{eid}');
      SQL
      @db_adapter.exec(command)
      project = TM::orm.project_get(pid)
      employee = TM::orm.employee_get(eid)
      return {project: project, employee: employee}
    end

    # TODO: testing
    # Returns a single project item
    def project_get(pid)
      command = <<-SQL
        SELECT * FROM projects WHERE id='#{pid}'
      SQL
      results = @db_adapter.exec(command).values.flatten
      # returns a single project entity specified by ID
      begin
        TM::Project.new(results)
      rescue TypeError
        puts "Can't retrieve project with ID= #{pid}" unless @test
        return
      end
    end


###########################################################################
########################### Tasks Model Methods ###########################
###########################################################################

    # REQUIRED, TESTED
    # Add a new task
    # associate task with a pid
    ##### DATABASE - adds a task into the db
    ##### RETURNS - a task entity
    def task_create(pid, priority, description)
      command = <<-SQL
        INSERT INTO tasks (proj_id, priority, description, creationTime)
        VALUES('#{pid}','#{priority}', '#{description}','#{Time.now.utc}' );
      SQL
      @db_adapter.exec(command)
      task_params = @db_adapter.exec("SELECT * FROM tasks ORDER BY id DESC LIMIT 1").values.flatten
      TM::Task.new(task_params)
    end

    # REQUIRED, TESTED
    # Assign task to employee
    # associate task to employee
    # RETURNS - a TASK entity and EMPLOYEE entity within a hash
    def task_assign(task_id, employee_id)
      command = <<-SQL
        UPDATE tasks SET
        employee_owner = '#{employee_id}'
        WHERE id='#{task_id}'
      SQL
      @db_adapter.exec(command)
      task = TM::orm.task_get(task_id)
      employee = TM::orm.employee_get(employee_id)
      return {task: task, employee: employee}
    end

    # REQUIRED, TESTED
    # Mark task TID as complete
    #### RETURNS - the a TASK entity that was just marked compelted
    def task_mark(task_id)
      command = <<-SQL
        UPDATE tasks SET
        completed = 't'
        WHERE id='#{task_id}'
      SQL
      @db_adapter.exec(command)
      task_get(task_id)
    end
    # TESTED
    # Returns a single TASK entity
    def task_get(task_id)
      command = <<-SQL
        SELECT * FROM tasks WHERE id='#{task_id}'
      SQL
      task_params = @db_adapter.exec(command).values.flatten
      # returns a single project entity specified by ID
      TM::Task.new(task_params)
    end

###########################################################################
######################## Database Reinitialization ########################
###########################################################################
    def create_all_tables
      create_projects_table
      create_tasks_table
      create_employees_table
      ## Join Tables **
      create_employeesprojects_table
      # create_projectstasks_table
      # create_employeestasks_table
    end

    def clear_db
      @db_adapter.exec("DROP schema public cascade;")
      @db_adapter.exec("CREATE schema public;")
      puts "Database Cleared".yellow unless @test
    end

    def reint_database
      puts "Starting Reinitialization".yellow unless @test
      clear_db
      create_all_tables
      puts "Completed Reinitialization".green unless @test
    end

###########################################################################
############################# Database Schema #############################
###########################################################################
    def create_projects_table
      command = <<-SQL
        CREATE TABLE projects(
        name text,
        id SERIAL,
        PRIMARY KEY(id)
        );
      SQL
      begin
        @db_adapter.exec(command)
      rescue
        puts "Error creating Projects table".red
        return
      end
      puts "Completed Creating Projects Table".green unless @test
    end

    def create_tasks_table
      # TODO CONFIRM THAT THIS WORKS
      # current_timestamp was not defaulting correctly
      # think this is fixed!
      command = <<-SQL
        CREATE TABLE tasks(
        id SERIAL,
        priority integer,
        description text,
        creationTime timestamp without time zone DEFAULT current_timestamp,
        proj_id integer REFERENCES projects(id),
        completed boolean DEFAULT false,
        employee_owner integer,
        PRIMARY KEY(id)
        );
      SQL
      begin
        @db_adapter.exec(command)
      rescue
        puts "Error creating Tasks table".red
        return
      end
      puts "Completed Creating Tasks Table".green unless @test
    end

    def create_employees_table
      command = <<-SQL
        CREATE TABLE employees(
        name text,
        id SERIAL,
        PRIMARY KEY(id)
        );
      SQL
      begin
        @db_adapter.exec(command)
      rescue
        puts "Error creating Employees table".red
        return
      end
      puts "Completed Creating Employees Table".green unless @test
    end

    # JOIN TABLES
    def create_employeesprojects_table
      command = <<-SQL
        CREATE TABLE employees_projects(
        id SERIAL,
        PRIMARY KEY(id),
        proj_id integer REFERENCES projects(id),
        employee_id integer REFERENCES employees(id)
        );
      SQL
      begin
        @db_adapter.exec(command)
      rescue
        puts "Error creating Employees-Projects table".red
        return
      end
      puts "Completed Creating Employees Table".green unless @test
    end

    # def create_employeestasks_table
    #   command = <<-SQL
    #     CREATE TABLE projects_tasks(
    #     id SERIAL,
    #     PRIMARY KEY(id),
    #     employee_id integer REFERENCES employees(id),
    #     task_id integer REFERENCES tasks(id)
    #     );
    #   SQL
    #   begin
    #     @db_adapter.exec(command)
    #   rescue
    #     puts "Error Creating Employee-Tasks table".red
    #     return
    #   end
    #   puts "Employee-Tasks Table Created".green
    # end

    # def create_projectstasks_table
    #   command = <<-SQL
    #     CREATE TABLE projects_tasks(
    #     id SERIAL,
    #     PRIMARY KEY(id),
    #     proj_id integer REFERENCES projects(id),
    #     task_id integer REFERENCES tasks(id)
    #     );
    #   SQL
    #   begin
    #     @db_adapter.exec(command)
    #   rescue
    #     puts "Error Creating Projects-Tasks table".red
    #     return
    #   end
    #   puts "Projects-Tasks Table Created".green
    # end

  end

  def self.orm
    @__orm_instance ||= ORM.new
  end


end
