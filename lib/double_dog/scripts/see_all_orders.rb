module DoubleDog
  class SeeAllOrders < TransactionScript
    def run(params)
      return failure(:not_admin) unless admin_session?(params[:admin_session])

      orders = DoubleDog.db.all_orders

      success(orders: orders)
    end
  end
end
