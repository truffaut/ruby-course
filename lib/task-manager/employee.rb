class TM::Employee

  attr_reader :name, :eid

  def initialize(params)
    @name = params[0]
    @eid = Integer(params[1])
  end

  def self.list
    begin
      TM::orm.employees_list
    rescue Exception => e
      puts e.inspect
    end
  end

  def self.create(name)
    begin
      TM::orm.employee_create(name)
    rescue Exception => e
      puts e.inspect
    end
  end

  # returns an array of projects which the employee
  # is recruited for
  def self.show(eid)
    begin
      TM::orm.employee_show_projects(eid)
    rescue Exception => e
      puts e.inspect
    end
  end

  # TODO
  def self.show_details(eid)

  end

  # TODO
  # RETURNS An array of completed tasks that hte employee owns
  def self.history(eid)
    TM::orm.employee_history(eid)
  end

  def self.get(eid)
    begin
      TM::orm.employee_get(eid)
    rescue Exception => e
      puts e.inspect
    end
  end

end

