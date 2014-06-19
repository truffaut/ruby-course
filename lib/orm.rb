require 'pg'
require 'pry-byebug'
require 'colorize'
module TM

  class ORM

    @DATABASE_NAME = 'task-manager'
    @HOST = 'localhost'

    def initialize
      @db_adapter = PG.connect(host: @HOST, dbname: @DATABASE_NAME)
    end

    def list_projects
      command = <<-SQL
        SELECT * FROM projects;
      SQL
      results = @db_adapter.exec(command).values
      results.map {|proj| TM::Project.new(proj[0], proj[1])}
    end

    def add_project(name)
      command = <<-SQL
        INSERT INTO projects (name)
        VALUES('#{name}');
      SQL
      @db_adapter.exec(command)
      proj = @db_adapter.exec("SELECT * FROM projects ORDER BY id DESC LIMIT 1").values.flatten
      # returns a single project entity that was just created
      TM::Project.new(proj[0], proj[1])
    end

    def get_project(pid)
      command = <<-SQL
        SELECT * FROM projects WHERE id='#{pid}'
      SQL
      results = @db_adapter.exec(command).values.flatten
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
      create_usersprojects_table
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

    def create_users_table
      command = <<-SQL
        CREATE TABLE users(
        name text,
        id SERIAL,
        PRIMARY KEY(id)
        );
      SQL
      begin
        @db_adapter.exec(command)
      rescue
        puts "Error creating Users table".red
        return
      end
      puts "Users Table Created".green
    end

    # JOIN TABLES
    def create_usersprojects_table
      command = <<-SQL
        CREATE TABLE users_projects(
        id SERIAL,
        PRIMARY KEY(id),
        ,proj_id integer REFERENCES projects(id),
        user_id integer REFERENCES users(id)
        );
      SQL
      begin
        @db_adapter.exec(command)
      rescue
        puts "Error creating Users-Projects table".red
        return
      end
      puts "Users-Projects Table Created".green
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
        puts "Error creating Projects-Tasks table".red
        return
      end
      puts "Users Table Created"
    end

  end

  def self.orm
    @__orm_instance ||= ORM.new
  end

end
