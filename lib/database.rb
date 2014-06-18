require 'pg'
module DBI
  # DBI.db.get_users(pid)

  class DB

    def initialize
      @__db_instance = PG.connect(host: 'localhost', dbname: 'task-manager')
    end

    def insert_project

    end

    def insert_task

    end

    def insert_user

    end

    #
    # Database Reint Functions
    #
    def create_all_tables
      create_projects_table
      create_tasks_table
      create_users_table
    end

    def clear_db(check)
      return nil if !check
      @__db_instance.exec("DROP schema public cascade;")
      @__db_instance.exec("CREATE schema public;")
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
      @__db_instance.exec(proj_table_schema)
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
      @__db_instance.exec(tasks_table_schema)
      puts "Tasks Table Created"
    end

    def create_users_table

      puts "TODO: Users Table Created"
    end

  end

  def self.db
    @__db_instance ||= DB.new
  end

end
