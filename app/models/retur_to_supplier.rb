class ReturToSupplier < ActiveRecord::Base
  has_many :retur_to_supplier_details
  def self.api(params)
    ActiveSupport::JSON.decode(params).each do |d|
      retur_to_supplier = self.new()
      retur_to_supplier.receipt_id = d["receiptId"]
      retur_to_supplier.note = d["note"]
      retur_to_supplier.supplier_id = d["supplierId"]
      retur_to_supplier.total = d["total"]
      retur_to_supplier.transaction_date = d["transactionDate"]
      retur_to_supplier.transaction_id = d["transactionId"]
      retur_to_supplier.user_id = d["userId"]
      retur_to_supplier.save!
      retur_to_supplier.create_details(d['returToSupplierDetails'])
    end
  end

  def create_details(params)
    params.each do |d|
      retur_to_supplier_detail = retur_to_supplier_details.new()
      retur_to_supplier_detail.price = d["price"]
      retur_to_supplier_detail.item_id = d["itemId"]
      retur_to_supplier_detail.quantity = d["quantity"]
      retur_to_supplier_detail.user_id = d["userId"]
      retur_to_supplier_detail.save!
    end
  end
end