class CartsController < ApplicationController
  # before execute checkout action, must authenticate user.
  before_action :authenticate_user!, :only => [:checkout]

  def index
  end

  def checkout
    # New a order of current user
    @order = current_user.orders.build
    # order has_one info, so use build_{class_name} not @order.{class_name}.build method
    @info = @order.build_info
  end
end
