class StockOp < ActiveRecord::Base
  has_many :stock_op_details, foreign_key: 'stok_op_id'

  def self.api(params)
    ActiveSupport::JSON.decode(params).each do |d|
      stock_op = self.new()
      stock_op.approved = d["approved"]
      stock_op.approved_date = d["approvedDate"]
      stock_op.description = d["description"]
      stock_op.transaction_date = d["transactionDate"]
      stock_op.transaction_id = d["transactionId"]
      stock_op.user_id = d["userId"]
      stock_op.save!
      stock_op.create_details(d['stockOpDetails'])
    end
  end

  def create_details(params)
    params.each do |d|
      stock_op_detail = stock_op_details.new()
      stock_op_detail.actual_quantity = d["actualQuantity"]
      stock_op_detail.item_id = d["itemId"]
      stock_op_detail.note = d["note"]
      stock_op_detail.stok_op_id = d["stokOpId"]
      stock_op_detail.virtual_quantity = d["virtualQuantity"]
      stock_op_detail.save!
    end
  end
end