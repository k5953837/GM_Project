class Cart < ActiveRecord::Base
  # if Cart is destoryed, the associated objects(cart_item) are destroyed
  # alongside this object by calling their destroy method
  has_many :cart_items, :dependent => :destroy

  # items (product here) is associated with cart_items
  has_many :items, :through => :cart_items, :source => :product

  def find_cart_item(product)
    cart_items.find_by(product_id: product)
  end

  def add_product_to_cart(product)
    items << product
  end

  def total_price
    # items.inject(0) { |sum, item| sum + item.price }

    sum = 0
    items.each do |item|
      sum = sum + item.price
    end
    return sum
  end

  def clean!
    cart_items.destroy_all
  end
end
