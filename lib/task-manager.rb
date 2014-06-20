
# Create our module. This is so other files can start using it immediately
module TM

  def self.run
    @active = true
    @history = []
    TM.start_message
    TM.help
    while @active
      TM.parse_command
    end
  end

  def self.parse_command
    print "TM-$: "
    # partition only partitions up to the first instance
    input = gets.chomp
    @history << input
    input = input.strip.partition(" ")
    command = input.first
    # split the remaining argument up
    args = input.last.split(" ")

    case command
      when "mark"
        # marks a task as completed
        # 1-takes 1 argument: tid
        TM.cmd_mark(args)
      when 'add'
        # adds a task to a project
        # 3-takes 3 arguments: pid, priority, desc
        TM.cmd_add(args)
      when 'history', 'show'
        # show the completed tasks
        # 1-takes one argument: project_id
        if command == "history"
          TM.history_show_helper(args, :history)
        elsif command == "show"
          TM.history_show_helper(args, :show)
        end
      when 'create'
        # create a project
        # 1-takes one argument: project_name
        TM.cmd_create(args)
      when 'list'
        # Lists all projects
        # 0-takes no arguments
        TM.cmd_list()
      when 'help'
        # shows a list of all commands
        # 0-takes no arguments
        TM.help
      when 'exit', 'q', 'quit'
        puts "Thank you for using the PM Terminal"
        @active = false
      else
        puts "I'm sorry, I am unable to do that..."
    end
  end
#
# Begin Commands
#
  def self.cmd_mark(args)
    if args.count != 1
      TM.invalid_args("arg count")
      return nil
    end
    tid = Integer(args.first)
    TM::Task.get_task(tid).mark_complete
  end

  def self.cmd_add(args)

    if args.count < 3
      TM.invalid_args("arg count")
      return nil
    end

    begin
      project_id = Integer(args[0])
      priority = Integer(args[1])
    rescue
      TM.invalid_args("need integers")
      return nil
    end

    project = TM::Project.get_project(project_id)
    if project == nil
      puts "project does not exist"
      return nil
    end
    desc = args[2..-1].join(" ")
    project.add_task(desc, priority)
    puts "Created task in #{project.name}"
    puts "-- DESCRIPTION: #{desc}"
  end


  def self.history_show_helper(args, type)
    # type is either :show or :history
    # completed will execute the show
    if args.count != 1
      puts "Wrong number of arguments."
      return nil
    end

    pid = Integer(args[0])
    project = TM::Project.get_project(pid)

    if project == nil
      puts "project with #{pid} could not be found"
      return nil
    end

    puts "ID: #{project.pid} - NAME: #{project.name}"

    if type == :history
      self.cmd_history(project)
    elsif type == :show
      self.cmd_show(project)
    end

  end

  def self.cmd_history(project)
    # Takes one argument
    # PID
    # show completed tasks for project id
    project.completed_tasks.each do |tk|
      self.print_task_info({:priority => tk.priority,
        :pid => tk.pid, :desc => tk.desc,
        :ctime => tk.creation_time, :tid => tk.task_id})
    end
  end

  def self.cmd_show(project)
    # Takes one argument
    # PID
    # show the remaining tasks for project id
    project.incomplete_tasks.each do |tk|
      self.print_task_info({:priority => tk.priority,
        :pid => tk.pid, :desc => tk.desc,
        :ctime => tk.creation_time, :tid => tk.task_id})
    end
  end

  def self.cmd_create(args)
    if args.count != 1
      puts "Wrong number of arguments."
      return nil
    end
    name = args[0]
    TM::Project.new(name)
    puts "New project created named: #{name}"
  end

  def self.cmd_list
    projects = TM::Project.get_projects
    if projects.empty?
      puts "You have no projects to list"
    else
      projects.each do |project|
        puts "ID: #{project.pid} - NAME: #{project.name}"
      end
    end
  end
#
# End Commands
#
#
# Begin Status Messages
#
  def self.invalid_args(type)
    case type
      when :number
        puts "invalid number of arguments!".red
      when :type
        puts "invalid type of arguments!".red
    end

  end

  def self.start_message
    puts "-------------------------------------------------------------"
    puts "Welcome to Project Manager Pro®. What can I do for you today?"
    puts "-------------------------------------------------------------"
  end

  def self.help
  puts "
  Available Commands:
  -- <name>-> <----<args>------> <-------<info>------------------------->
  -- help                       - Show these commands again
  -- list                       - List all projects
  -- create   NAME              - Create a new project with name=NAME
  -- show     PID               - Show remaining tasks for project with id=PID
  -- history  PID               - Show completed tasks for project with id=PID
  -- add      PID PRIORITY DESC - Add a new task to project with id=PID
  -- mark     TID               - Mark task with id=TID as complete
  -- exit/q,quit                       - exits the program
  ".yellow

  end

  # :priority, :desc, :pid, :ctime, :tid
  def self.print_task_info(tsk)
    puts "
    Task ID: #{tsk[:tid]}
    Priority: #{tsk[:priority]} | Creation Time: #{tsk[:ctime]}
    #{tsk[:desc]}
    "
  end
#
# End Status Messages
#
end

# Require all of our project files
require_relative 'task-manager/task.rb'
require_relative 'task-manager/project.rb'
require_relative 'task-manager/employee.rb'
require_relative 'orm.rb'
require 'pry-byebug'
require 'colorize'
require 'pg'

