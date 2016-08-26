class Account::OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    # use scope(recent scope) to simplify code and readable
    @orders = current_user.orders.recent
  end
end
