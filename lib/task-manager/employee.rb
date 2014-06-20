class TM::Employee

  attr_reader :name, :eid

  def initialize(name, eid)
    @name = name
    @eid = Integer(eid)
  end

end

