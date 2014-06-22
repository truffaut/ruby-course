
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
          exit_message
          exit
      end
    end

    type = input.shift
    command = input.shift
    args = input

    # DONE
    if command == 'create'
      case type
        when 'project'
          # project create NAME
          arg1 = args.join(" ")
          return TM::Commands.project_create(arg1)
        when 'task'
          arg1 = args.shift
          arg2 = args.shift
          arg3 = args.join(" ")
          return TM::Commands.task_create(arg1, arg2, arg3)
        when 'emp'
          arg1 = args.join(" ")
          return TM::Commands.emp_create(arg1)
      end
    end

    #########################
    ## NO ARGUMENT COMMAND ##
    #########################
    if args.count == 0
      case type
        when 'project'
          if command == 'list'
            # project list DONE
            return TM::Commands.project_list
          else
            puts "Command Not Found".red
          end
        when 'emp'
          if command == 'list'
            # emp list, TODO
            return TM::Commands.emp_list
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
          if command == 'show'
            # project show PID
            return TM::Commands.project_show(arg1)
          elsif command == 'history'
            # project history PID, TODO
            return TM::Commands.project_history(arg1)
          elsif command == 'employees'
            # project employees PID, TODO
            return TM::Commands.project_employees(arg1)
          else
            puts "Project Command Not Found!".red
          end
        when 'task'
          if command == 'mark'
            # task mark TID, TODO
            return TM::Commands.task_mark(arg1)
          else
            puts "Task Command Not Found!".red
          end
        when 'emp'
          if command == 'show'
            # emp show EID, TODO
            return TM::Commands.emp_show(arg1)
          elsif command == 'details'
            # emp details EID, TODO
            return TM::Commands.emp_details(arg1)
          elsif command == 'history'
            # emp history EID, TODO
            return TM::Commands.emp_history(arg1)
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
            # TODO
            return TM::Commands.project_recruit(arg1, arg2)
          else
            puts "Command Not Found".red
          end
        when 'task'
          if command == 'assign'
            # TODO
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
    puts " project history   PID       = Show completed tasks for project PID".red
    puts " project employees PID       = Show employees participating in this project".red
    puts " project recruit   PID EID   = Adds employee EID to participate in project PID".red
    puts " task create       PID PRIORITY DESCRIPTION".blue
    puts "                          ^^ = Add a new task to project PID".light_blue
    puts " task assign       TID EID   = Assign task to employee".red
    puts " task mark         TID       = Mark task TID as complete".yellow
    puts " emp list          ----      = List all employees".blue
    puts " emp create        NAME      = Create a new employee".light_blue
    puts " emp show          EID       = Show employee EID and all participating projects".red
    puts " emp details       EID       = Show all remaining tasks assigned to employee EID,".red
    puts "                                along with the project name next to each task".red
    puts " emp history       EID       = Show completed tasks for employee with id=EID".red
    puts " help              ----      = Show these commands again".light_blue
    puts " exit/q/quit       ----      = Exit Program".blue
    puts " ------------------------------------------------------------------------------------".blue
  end

  def self.exit_message
    puts "-------------------------------------------------------------".green
    puts "------------------ Thanks for being Awesome -----------------".green
    puts "-------------------------------------------------------------".green
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

