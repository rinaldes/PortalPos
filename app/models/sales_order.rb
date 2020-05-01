class SalesOrder < ActiveRecord::Base
  has_many :sale_order_details, foreign_key: 'sales_order_id'
  has_many :retur_orders
  def self.api(params)
    ActiveSupport::JSON.decode(params).each do |d|
      sale_order = self.new()
      sale_order.cashier_id = d["cashierId"]
      sale_order.cashier_name = d["cashierName"]
      sale_order.delivered = d["delivered"]
      sale_order.delivery_date = d["deliveryDate"]
      sale_order.delivery_instruction = d["deliveryInstruction"]
      sale_order.discount_nominal = d["discountNominal"]
      sale_order.dispatched_by = d["dispatchedBy"]
      sale_order.due_date = d["dueDate"]
      sale_order.fat = d["fat"]
      sale_order.gross = d["gross"]
      sale_order.member_id = d["memberId"]
      sale_order.nett = d["nett"]
      sale_order.ordered_by = d["orderedBy"]
      sale_order.paid = d["paid"]
      sale_order.pengirim_id = d["pengirimId"]
      sale_order.promotion_id = d["promotionId"]
      sale_order.remarks = d["remarks"]
      sale_order.retur = d["retur"]
      sale_order.sales_order_date = d["salesOrderDate"]
      sale_order.salesman_id = d["salesmanId"]
      sale_order.so_number = d["soNumber"]
      sale_order.supervisor_id = d["supervisorId"]
      sale_order.tax
      sale_order.save!
      sale_order.create_details(d['salesOrderDetails'])
    end
  end

  def self.api2(params)
    ActiveSupport::JSON.decode(params).each do |d|
      sale_order = self.find(d["id"])
      sale_order.delivered = d["delivered"]
      sale_order.delivery_date = d["deliveryDate"]
      sale_order.delivery_instruction = d["deliveryInstruction"]
      sale_order.tax
      sale_order.save!
    end
  end

  def create_details(params)
    params.each do |d|
      sale_order_detail = sale_order_details.new()
      sale_order_detail.base_price = d["basePrice"]
      sale_order_detail.count = d["count"]
      sale_order_detail.discount_nominal = d["discountNominal"]
      sale_order_detail.discount_percent = d["discountPercent"]
      sale_order_detail.item_id = d["itemId"]
      sale_order_detail.promotion_id = d["promotionId"]
      sale_order_detail.retur_quantity = d["returQuantity"]
      sale_order_detail.selling_price = d["sellingPrice"]
      sale_order_detail.save!
    end
  end
end