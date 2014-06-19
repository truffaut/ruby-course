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

    # REQUIRED
    # COMMAND
    # List all employees
    ##### RETURNS - a an array of employee entity
    def employees_list()

    end

    # REQUIRED
    # COMMAND
    # Create a new employee
    ##### DATABASE - addes employee to database
    ##### RETURNS - a employee entity
    def employee_create(employee_name)

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

    # REQUIRED
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

    # REQUIRED
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

    # REQUIRED
    # COMMAND
    # Show remaining tasks for project PID
    def project_show(proj_id)

    end

    # REQUIRED
    # COMMAND
    # Show completed tasks for project PID
    def project_history(proj_id)

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
    # Add a new task to project PID
    def task_create(pird, priority, desc)

    end
    # REQUIRED
    # Assign task to employee
    def task_assign(task_id, employee_id)

    end

    # REQUIRED
    # Mark task TID as complete
    def task_mark(task_id)

    end

###########################################################################
######################## Database Reinitialization ########################
###########################################################################
    def create_all_tables
      create_projects_table
      create_tasks_table
      create_employees_table
      create_employeesprojects_table
      create_projectstasks_table
    end

    def clear_db(check)
      return nil if !check
      @db_adapter.exec("DROP schema public cascade;")
      @db_adapter.exec("CREATE schema public;")
      puts "Database Cleared".green
    end

    def reint_database
      puts "Reinitialization Started".green
      clear_db(true)
      create_all_tables
      puts "Reinitialization Complete".green
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
      puts "Projects Table Created".green
    end

    def create_tasks_table
      command = <<-SQL
        CREATE TABLE tasks(
        id SERIAL,
        priority integer,
        creationTime text,
        description text,
        completed boolean,
        PRIMARY KEY(id)
        );
      SQL
      begin
        @db_adapter.exec(command)
      rescue
        puts "Error creating Tasks table".red
        return
      end
      puts "Tasks Table Created".green
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
      puts "Employees Table Created".green
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
      puts "Employees-Projects Table Created".green
    end

    def create_projectstasks_table
      command = <<-SQL
        CREATE TABLE projects_tasks(
        id SERIAL,
        PRIMARY KEY(id),
        proj_id integer REFERENCES projects(id),
        task_id integer REFERENCES tasks(id)
        );
      SQL
      begin
        @db_adapter.exec(command)
      rescue
        puts "Error Creating Projects-Tasks table".red
        return
      end
      puts "Projects-Tasks Table Created".green
    end

  end

  def self.orm
    @__orm_instance ||= ORM.new
  end

end
