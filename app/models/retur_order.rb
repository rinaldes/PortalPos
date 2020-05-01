class ReturOrder < ActiveRecord::Base
  has_many :retur_order_details
  belongs_to :member
  belongs_to :user
  belongs_to :sale_transaction
  belongs_to :sales_order

  def self.api(params)
    ActiveSupport::JSON.decode(params).each do |d|
      retur_order = self.new()
      retur_order.description = d["description"]
      retur_order.member_id = d["memberId"]
      retur_order.sales_order_id = d["salesOrderId"]
      retur_order.total = d["total"]
      retur_order.transaction_date = d["transactionDate"]
      retur_order.transaction_id = d["transactionId"]
      retur_order.user_id = d["userId"]
      retur_order.save!
      retur_order.create_details(d['returOrderDetails'])
    end
  end

  def create_details(params)
    params.each do |d|
      retur_order_detail = retur_order_details.new()
      retur_order_detail.base_price = d["basePrice"]
      retur_order_detail.item_id = d["itemId"]
      retur_order_detail.quantity = d["quantity"]
      retur_order_detail.selling_price = d["sellingPrice"]
      retur_order_detail.save!
    end
  end
end