class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def admin_required
    if !current_user.admin?
      redirect_to "/"
    end
  end

  # Added helper at controller, then we can use this helper at view
  helper_method :current_cart

  def current_cart
    # if @current_cart is not null then return @current_cart, otherwise execute find_cart function
    @current_cart ||= find_cart
  end

  private

  def find_cart
    # find cart_id from session, then we will known whether the cart is exist
    cart = Cart.find_by(id: session[:cart_id])

    # if we can find cart from session, we create the cart for user.
    unless cart.present?
      cart = Cart.create
    end

    # set the cart id to session
    session[:cart_id] = cart.id
    cart
  end
end
