module DoubleDog
  class CreateOrder < TransactionScript
    def run(params)
      user = DoubleDog.db.get_user_by_session_id(params[:session_id])
      return failure(:invalid_session) if user.nil?
      return failure(:no_items_ordered) unless valid_items?(params[:items])

      order = DoubleDog.db.create_order(employee_id: user.id, items: params[:items])

      success(order: order)
    end

    def valid_items?(items)
      items != nil && items.count >= 1
    end
  end
end
