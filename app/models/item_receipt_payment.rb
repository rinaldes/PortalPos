class ItemReceiptPayment < ActiveRecord::Base
  def self.api(params)
    ActiveSupport::JSON.decode(params).each do |d|
      item_receipt_payment = self.new
      item_receipt_payment.account_bank_destination = d["accountBankDestination"]
      item_receipt_payment.account_bank_source = d["accountBankSource"]
      item_receipt_payment.account_branch_destination = d["accountBranchDestination"]
      item_receipt_payment.account_branch_source = d["accountBranchSource"]
      item_receipt_payment.account_name_destination = d["accountNameDestination"]
      item_receipt_payment.account_name_source = d["accountNameSource"]
      item_receipt_payment.account_number_destination = d["accountNumberDestination"]
      item_receipt_payment.account_number_source = d["accountNumberSource"]
      item_receipt_payment.cashier_id = d["cashierId"]
      item_receipt_payment.cashier_name = d["cashierName"]
      item_receipt_payment.item_receipt_id = d["itemReceiptId"]
      item_receipt_payment.nominal = d["nominal"]
      item_receipt_payment.pay_left = d["payLeft"]
      item_receipt_payment.payment_date = d["paymentDate"]
      item_receipt_payment.payment_number = d["paymentNumber"]
      item_receipt_payment.payment_type = d["paymentType"]
      item_receipt_payment.supplier_id = d["supplierId"]
      item_receipt_payment.save!
    end
  end
end