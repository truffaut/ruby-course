class TM::Employee

  attr_reader :name, :eid

  def initialize(params)
    # name, eid
    # proj[0], proj[1]
    @name = params[0]
    @eid = Integer(params[1])
  end

end

