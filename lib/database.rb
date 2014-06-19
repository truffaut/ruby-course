require 'pg'
require 'pry-byebug'
module TM
  # TM::db.get_users(pid)

  class DB

    @DATABASE_NAME = 'task-manager'
    @HOST = 'localhost'

    def initialize
      @db = PG.connect(host: @HOST, dbname: @DATABASE_NAME)
    end

    def list_projects
      command = <<-SQL
        SELECT * FROM projects;
      SQL
      results = @db.exec(command).values
      results.map {|proj| TM::Project.new(proj[0], proj[1])}
    end

    def add_project(name)
      command = <<-SQL
        INSERT INTO projects (name)
        VALUES('#{name}');
      SQL
      @db.exec(command)
      proj = @db.exec("SELECT * FROM projects ORDER BY id DESC LIMIT 1").values.flatten
      # returns a single project entity that was just created
      TM::Project.new(proj[0], proj[1])
    end

    def get_project(pid)
      command = <<-SQL
        SELECT * FROM projects WHERE id='#{pid}'
      SQL
      results = @db.exec(command).values.flatten
      # returns a single project entity specified by ID
      TM::Project.new(results[0], results[1])
    end

###########################################################################
######################## Database Reinitialization ########################
###########################################################################
    def create_all_tables
      create_projects_table
      create_tasks_table
      create_users_table
      # create_usersprojects_table
      # create_projectstasks_table
    end

    def clear_db(check)
      return nil if !check
      @db.exec("DROP schema public cascade;")
      @db.exec("CREATE schema public;")
      puts "Database Cleared"
    end

    def reint_database
      puts "Reinitialization Started"
      clear_db(true)
      create_all_tables
      puts "Reinitialization Complete"
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
      @db.exec(command)
      puts "Projects Table Created"
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
      @db.exec(command)
      puts "Tasks Table Created"
    end

    def create_users_table
      command = <<-SQL
        CREATE TABLE users(
        name text,
        id SERIAL,
        PRIMARY KEY(id)
        );
      SQL
      @db.exec(command)
      puts "Users Table Created"
    end
    # JOIN TABLES
    def create_usersprojects_table
      command = <<-SQL
        CREATE TABLE users_projects(
        id SERIAL,
        PRIMARY KEY(id)
        proj_id integer REFERENCES projects(id),
        user_id integer REFERENCES users(id)
        );
      SQL
      @db.exec(command)
      puts "Users-Projects Table Created"
    end

    def create_projectstasks_table
      command = <<-SQL
        CREATE TABLE projects_tasks(
        id SERIAL,
        PRIMARY KEY(id)
        proj_id integer REFERENCES projects(id),
        task_id integer REFERENCES task(id),
        );
      SQL
      @db.exec(command)
      puts "Users Table Created"
    end


  end

  def self.db
    @__db_instance ||= DB.new
  end

end
