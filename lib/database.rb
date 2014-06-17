require 'pg'
module DBI
  # DBI.db.get_users(pid)

  class DB

    def initialize
      PG.connect
    end


  end

  def self.db
    @__db_instance ||= DB.new
  end

end
