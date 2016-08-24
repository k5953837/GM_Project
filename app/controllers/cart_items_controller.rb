class CartItemsController < ApplicationController
  # before execute any action, user must log in.
  before_action :authenticate_user!

  def update
    @cart = current_cart
    @item = @cart.find_cart_item(params[:id])

    # user can't manually modify the quantity of shopping cart item if the quantity is not enough.
    if @item.product.quantity >= item_params[:quantity].to_i
      @item.update(item_params)
      flash[:notice] = "成功變更數量"
    else
      flash[:warning] = "數量不足以加入購物車"
    end

    redirect_to carts_path
  end

  def destroy
    @cart = current_cart
    @item = @cart.find_cart_item(params[:id])
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
