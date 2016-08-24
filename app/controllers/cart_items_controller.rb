class CartItemsController < ApplicationController
  # before execute any action, user must log in.
  before_action :authenticate_user!

  def update
    @cart = current_cart
    @item = @cart.cart_items.find_by(product_id: params[:id])

    @item.update(item_params)

    redirect_to carts_path
  end

  def destroy
    @cart = current_cart
    @item = @cart.cart_items.find_by(product_id: params[:id])
    @product = @item.product
    @item.destroy

    flash[:warning] = "成功將 #{@product.title} 從購物車移除！"
    redirect_to :back
  end

  private

  def item_params
    params.require(:cart_item).permit(:quantity)
  end
end
