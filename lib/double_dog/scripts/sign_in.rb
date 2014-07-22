require 'pry-byebug'
module DoubleDog
  class SignIn < TransactionScript

    def run(params)
      return failure(:invalid_username) unless valid_username?(params[:username])
      return failure(:invalid_password) unless valid_password?(params[:password])

      user = DoubleDog.db.get_user_by_username(params[:username])

      return failure(:no_such_user) if user.nil?
      return failure(:invalid_password) unless user.has_password?(params[:password])

      session_id = DoubleDog.db.create_session(user_id: user.id)
      retrieved_user = DoubleDog.db.get_user_by_session_id(session_id)

      success(:user => retrieved_user, :session_id => session_id)
    end

    def valid_username?(username)
      !username.nil? && username != ''
    end

    def valid_password?(password)
      !password.nil? && password != ''
    end
  end
end
