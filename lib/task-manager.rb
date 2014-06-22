
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
    print "TM-$: ".red
    input = gets.chomp.downcase.split

    # Input is a single command
    if input.count == 1
      case input[0]
        when 'help'
          return TM.help
          # return self.parse_command
        when 'exit','q','quit'
          exit
      end
    end

    type = input.shift
    command = input.shift
    args = input

    #########################
    ## NO ARGUMENT COMMAND ##
    #########################
    if args.count == 0
      case type
        when 'project'
          if command == 'list'
            # project list
            return TM::Commands.project_list
          else
            puts "Command Not Found".red
          end
        when 'emp'
          if command == 'list'
            # emp list
            return TM::Command.employees_list
          else
            puts "Command Not Found".red
          end
        else
          puts "Command Type Not Found".red
      end
    end

    ##########################
    ## ONE ARGUMENT COMMAND ##
    ##########################
    if args.count == 1
      arg1 = args.shift
      case type
        when 'project'
          if command == 'create'
            # project create NAME
            return TM::Commands.project_create(arg1)
          elsif command == 'show'
            # project show PID
            return TM::Commands.project_show(arg1)
          elsif command == 'history'
            # project history PID
            return TM::Commands.project_history(arg1)
          elsif command == 'employees'
            # project employees PID
            return TM::Commands.project_employees(arg1)
          else
            puts "Project Command Not Found!".red
          end
        when 'task'
          if command == 'mark'
            return TM::Commands.task_mark(arg1) # task mark TID
          else
            puts "Task Command Not Found!".red
          end
        when 'emp'
          if command == 'create'
            return TM::Commands.emp_create(arg1) # emp create NAME
          elsif command == 'show'
            return TM::Commands.emp_show(arg1) # emp show EID
          elsif command == 'details'
            return TM::Commands.emp_details(arg1) # emp details EID
          elsif command == 'history'
            return TM::Commands.emp_history(arg1) # emp history EID
          else
            puts "Employee Command Not Found".red
          end
      else
        puts "Command Type Not Found".red
      end
    end

    ##########################
    ## TWO ARGUMENT COMMAND ##
    ##########################
    if args.count == 2
      arg1 = args.shift
      arg2 = args.shift
      case type
        when 'project'
          if command == 'recruit'
            return TM::Commands.project_recruit(arg1, arg2)
          else
            puts "Command Not Found".red
          end
        when 'task'
          if command == 'assign'
            return TM::Commands.task_assign(arg1, arg2)
          else
            puts "Command Not Found".red
          end
        else
          puts "Command Type Not Found".red
      end
    end

    ############################
    ## THREE ARGUMENT COMMAND ##
    ############################
    # task create PID PRIORITY DESC
    if args.count > 2
      arg1 = args.shift
      arg2 = args.shift
      arg3 = args.join(" ")
      case type
        when 'task'
          if command == 'create'
            return TM::Commands.task_create(arg1, arg2, arg3)
          else
            puts "Command Not Found".red
          end
        else
          puts "Command Type Not Found".red
      end

    end
    puts "THIS SHOULD NOT BE RUNNING!".red
  end

#
# Begin Status Messages
#

  def self.start_message
    puts "-------------------------------------------------------------".green
    puts "Welcome to Project Manager Pro®. What can I do for you today?".green
    puts "-------------------------------------------------------------".green
  end

  def self.help
    puts " Available Commands: ---------------------------------------------------------------".blue
    puts " project list      ----      = List all projects".light_blue
    puts " project create    NAME      = Create a new project".blue
    puts " project show      PID       = Show remaining tasks for project PID".light_blue
    puts " project history   PID       = Show completed tasks for project PID".blue
    puts " project employees PID       = Show employees participating in this project".light_blue
    puts " project recruit   PID EID   = Adds employee EID to participate in project PID".blue
    puts " task create       PID PRIORITY DESCRIPTION".blue
    puts "                          ^^ = Add a new task to project PID".light_blue
    puts " task assign       TID EID   = Assign task to employee".blue
    puts " task mark         TID       = Mark task TID as complete".light_blue
    puts " emp list          ----      = List all employees".blue
    puts " emp create        NAME      = Create a new employee".light_blue
    puts " emp show          EID       = Show employee EID and all participating projects".blue
    puts " emp details       EID       = Show all remaining tasks assigned to employee EID,".light_blue
    puts "                                along with the project name next to each task".light_blue
    puts " emp history       EID       = Show completed tasks for employee with id=EID".blue
    puts " help              ----      = Show these commands again".light_blue
    puts " exit/q/quit       ----      = Exit Program".blue
    puts " ------------------------------------------------------------------------------------".blue
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
require_relative 'commands.rb'
require 'pry-byebug'
require 'colorize'
require 'pg'

