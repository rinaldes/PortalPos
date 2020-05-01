class SaleTransactionDetail < ActiveRecord::Base
	belongs_to :sale_transaction, foreign_key: 'transaction_id'
  def self.api(params)
    params.each do |d|
      raise d.inspect
      sale_transaction_detail = self.new()
      sale_transaction_detail.base_price = d["base_price"]
      sale_transaction_detail.count = d["count"]
      sale_transaction_detail.discount_nominal = d["discount_nominal"]
      sale_transaction_detail.discount_percent = d["discount_percent"]
      sale_transaction_detail.item_id = d["item_id"]
      sale_transaction_detail.promotional_id = d["promotional_id"]
      sale_transaction_detail.retur_quatity = d["retur_quatity"]
      sale_transaction_detail.selling_price = d["selling_price"]
      sale_transaction_detail.save!
    end
  end
end
