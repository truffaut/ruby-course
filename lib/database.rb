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


  end

  def self.db
    @__db_instance ||= DB.new
  end

  # DATABASE SCHEMA
  def creat_projects_table
    proj_table_schema = <<-SQL
      CREATE TABLE projects(
      name text,
      id SERIAL,
      PRIMARY KEY(id)
      );
    SQL
    @__db_instance.exec(proj_table_schema)
  end
  
  def self.create_tasks_table
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
    self.db.exec(tasks_table_schema)
  end

  def self.create_users_table

  end

  def self.clear_db(check)
    return nil if !check
    self.db.exec("DROP schema public cascade;")
  end

  def self.reinitialize_db_scheme(bool)
    return nil if !bool
    self.clear_db(true)
  end
end
