class TransactionScript
  private
  def self.run(inputs)
    self.new.run(inputs)
  end

  def admin_session?(session_id)
    user = DoubleDog.db.get_user_by_session_id(session_id)
    user && user.admin?
  end

  def failure(error_name)
    { :success? => false, :error => error_name }
  end

  def success(data)
    data.merge(:success? => true)
  end
end
