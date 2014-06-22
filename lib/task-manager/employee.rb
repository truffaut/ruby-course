class TM::Employee

  attr_reader :name, :eid

  def initialize(params)
    @name = params[0]
    @eid = Integer(params[1])
  end

  def self.list
    TM::orm.employees_list
  end

  def self.create(name)
    TM::orm.employee_create(name)
  end

  # TODO
  def self.show(eid)

  end

  # TODO
  def self.show_details(eid)

  end

  # TODOS
  def self.history(eid)

  end

end

