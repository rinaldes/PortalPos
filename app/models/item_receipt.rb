class ItemReceipt < ActiveRecord::Base
  has_many :item_receipt_details
  def self.api(params)
    ActiveSupport::JSON.decode(params).each do |d|
      item_receipt = self.new()
      item_receipt.description = d["description"]
      item_receipt.discountNominal = d["discountNominal"]
      item_receipt.due_date = d["dueDate"]
      item_receipt.employee_id = d["employeeId"]
      item_receipt.nett = d["nett"]
      item_receipt.paid = d["paid"]
      item_receipt.payment_type = d["paymentType"]
      item_receipt.po_number = d["poNumber"]
      item_receipt.receipt_date = d["receiptDate"]
      item_receipt.receipt_number = d["receiptNumber"]
      item_receipt.receiver_name = d["receiverName"]
      item_receipt.retur = d["retur"]
      item_receipt.supplier_id = d["supplierId"]
      item_receipt.tax = d["tax"]
      item_receipt.save!
      item_receipt.create_details(d['itemReceiptDetails'])
    end
  end

  def create_details(params)
    params.each do |d|
      item_receipt_detail = item_receipt_details.new()
      item_receipt_detail.item_id = d["itemId"]
      item_receipt_detail.item_receipt_id = d["itemReceiptId"]
      item_receipt_detail.price = d["price"]
      item_receipt_detail.receipt_count = d["receiptCount"]
      item_receipt_detail.save!
    end
  end
end