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

    def store_project()

    end

    def store_task()

    end

    def store_user()

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
    end

    #
    # Database Re-int Functions
    #
    def create_all_tables
      create_projects_table
      create_tasks_table
      create_users_table
    end

    def clear_db(check)
      return nil if !check
      # TM::db.exec("DROP schema public cascade;")
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

    #
    # Database Schema
    #

    def create_projects_table
      proj_table_schema = <<-SQL
        CREATE TABLE projects(
        name text,
        id SERIAL,
        PRIMARY KEY(id)
        );
      SQL
      @db.exec(proj_table_schema)
      puts "Projects Table Created"
    end

    def create_tasks_table
      tasks_table_schema = <<-SQL
        CREATE TABLE tasks(
        id SERIAL,
        priority integer,
        creationTime text,
        description text,
        completed boolean,
        proj_id integer REFERENCES projects(id),
        PRIMARY KEY(id)
        );
      SQL
      @db.exec(tasks_table_schema)
      puts "Tasks Table Created"
    end

    def create_users_table
      # TODO:
      puts "Users Table Created"
    end

  end

  def self.db
    @__db_instance ||= DB.new
  end

end
