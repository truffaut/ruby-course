require 'pg'
require 'pry-byebug'
require 'colorize'
module TM

  class ORM

    attr_reader       :db_adapter
    @DATABASE_NAME  = 'task-manager'
    @HOST           = 'localhost'

    def initialize
      @db_adapter = PG.connect(host: @HOST, dbname: @DATABASE_NAME)
    end

###########################################################################
########################### Employees Model Methods ###########################
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
      results.map {|proj| TM::Employee.new(proj[0], proj[1].to_i)}
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
      proj = @db_adapter.exec("SELECT * FROM employees ORDER BY id DESC LIMIT 1").values.flatten
      Employee.new(proj[0], proj[1])
    end

    # REQUIRED
    # COMMAND
    # Show employee EID and all participating projects
    def employee_show_projects(employee_id)

    end

    # REQUIRED
    # COMMAND
    # Show all remaining tasks assigned to employee EID,
    # along with the project name next to each task
    def employee_details(employee_id)

    end

    # REQUIRED
    # COMMAND
    # Show completed tasks for employee
    def employee_history(employee_id)

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
      results = @db_adapter.exec(command).values
      results.map {|proj| TM::Project.new(proj[0], proj[1])}
    end

    # REQUIRED, TESTED
    # COMMAND
    # Create a new project
    ##### DATABASE - addes project to database
    ##### RETURNS - a project entity
    def project_create(name)
      command = <<-SQL
        INSERT INTO projects (name)
        VALUES('#{name}');
      SQL
      @db_adapter.exec(command)
      proj = @db_adapter.exec("SELECT * FROM projects ORDER BY id DESC LIMIT 1").values.flatten
      TM::Project.new(proj[0], proj[1])
    end

    # REQUIRED, TESTED
    # COMMAND
    # Show remaining tasks for project PID, completed = 'f'
    # returns an array of TASK entities
    def project_show(proj_id)
      command = <<-SQL
        SELECT * FROM tasks
        WHERE proj_id='#{proj_id}'
        AND comleted='f';
      SQL
      incomplete_results = @db_adapter.exec(command).values
      incomplete_results.map {|proj| TM::Project.new(proj[0], proj[1])}
    end

    # REQUIRED
    # COMMAND
    # Show completed tasks for project PID
    def project_history(proj_id)
      # TODO
      command = <<-SQL
        SELECT * FROM tasks
        WHERE proj_id='#{proj_id}'
        AND comleted='t';
      SQL
      incomplete_results = @db_adapter.exec(command).values
      incomplete_results.map {|proj| TM::Project.new(proj[0], proj[1])}
    end

    # REQUIRED
    # COMMAND
    # Show employees participating in this project
    def project_employees(proj_id)

    end

    # REQUIRED
    # COMMAND
    # Adds employee EID to participate in project PID
    def project_recruit(proj_id)

    end

    # Returns a single project item
    def project_get(pid)
      command = <<-SQL
        SELECT * FROM projects WHERE id='#{pid}'
      SQL
      results = @db_adapter.exec(command).values.flatten
      # returns a single project entity specified by ID
      TM::Project.new(results[0], results[1])
    end


###########################################################################
########################### Tasks Model Methods ###########################
###########################################################################

    # REQUIRED
    # Add a new task
    # associate task with a pid
    def task_create(pid, priority, description)
      command = <<-SQL
        INSERT INTO tasks (proj_id, priority, description, creationTime)
        VALUES('#{pid}','#{priority}', '#{description}','#{Time.now.utc}' );
      SQL
      @db_adapter.exec(command)
      task = @db_adapter.exec("SELECT * FROM tasks ORDER BY id DESC LIMIT 1").values.flatten
      TM::Task.new(task[0], task[1], task[2], task[3], task[4], task[5])
    end
    # REQUIRED
    # Assign task to employee
    # associate task to employee
    def task_assign(task_id, employee_id)

    end

    # REQUIRED
    # Mark task TID as complete
    # returns the a TASK entity that was just marked compelted
    def task_mark(task_id)
      command = <<-SQL
        UPDATE tasks SET
        completed = 't'
        WHERE id='#{task_id}'
      SQL
      @db_adapter.exec(command)
      task_get(task_id)
    end

    # Returns a single TASK entity
    def task_get(task_id)
      command = <<-SQL
        SELECT * FROM tasks WHERE id='#{task_id}'
      SQL
      results = @db_adapter.exec(command).values.flatten
      # returns a single project entity specified by ID
      TM::Task.new(results[0], results[1], results[2], results[3], results[4], results[5])
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
    end

    def reint_database
      clear_db
      create_all_tables
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
    end

    def create_tasks_table
      # FIXME current_timestamp
      command = <<-SQL
        CREATE TABLE tasks(
        id SERIAL,
        priority integer,
        description text,
        creationTime timestamp without time zone DEFAULT current_timestamp,
        proj_id integer REFERENCES projects(id),
        completed boolean DEFAULT false,
        PRIMARY KEY(id)
        );
      SQL
      begin
        @db_adapter.exec(command)
      rescue
        puts "Error creating Tasks table".red
        return
      end
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
