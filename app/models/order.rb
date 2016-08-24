class Order < ActiveRecord::Base
  before_create :generate_token
  belongs_to :user

  has_many :items, class_name: "OrderItem", dependent: :destroy
  has_one :info, class_name: "OrderInfo", dependent: :destroy

  # genertate radom token before create a order
  def generate_token
    self.token = SecureRandom.uuid
  end

  # Declare the :info (order associated with orderinfo) has nested attributes structure
  # including buildind_name / building_address / shipping name / shipping address.
  accepts_nested_attributes_for :info

  def build_item_cache_from_cart(cart)
    cart.items.each do |cart_item|
      item = items.build
      item.product_name = cart_item.title
      item.quantity = cart.find_cart_item(cart_item).quantity
      item.price = cart_item.price
      item.save
    end
  end

  # Calculate the shopping cart total money.
  def calculate_total!(current_cart)
    self.total = current_cart.total_price
    self.save
  end

  def set_payment_with!(method)
    self.update_column(:payment_method, method)
  end

  def pay!
    self.update_column(:is_paid, true)
  end

  include AASM

  aasm do
    # Define 6 state for product status
    state :order_placed, :initial => true
    state :paid
    state :shipping
    state :shipped
    state :order_cancelled
    state :good_returned

    # if aasm_state column is paid state, then execute pay! method
    event :make_payment, after_commit: :pay! do
      transitions from: :order_placed, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :shipping
    end

    event :deliver do
      transitions from: :shipping, to: :shipped
    end

    event :return_good do
      transitions from: :shipped, to: :good_returned
    end

    event :cancel_order do
      transitions from: [:order_placed, :paid], to: :order_cancelled
    end
  end

end
