class SalesOrderPayment < ActiveRecord::Base
  def self.api(params)
    ActiveSupport::JSON.decode(params).each do |d|
      sales_order_payment = self.new
      sales_order_payment.account_bank_destination = d["accountBankDestination"]
      sales_order_payment.account_bank_source = d["accountBankSource"]
      sales_order_payment.account_branch_destination = d["accountBranchDestination"]
      sales_order_payment.account_branch_source = d["accountBranchSource"]
      sales_order_payment.account_name_destination = d["accountNameDestination"]
      sales_order_payment.account_name_source = d["accountNameSource"]
      sales_order_payment.account_number_destination = d["accountNumberDestination"]
      sales_order_payment.account_number_source = d["accountNumberSource"]
      sales_order_payment.cashier_id = d["cashierId"]
      sales_order_payment.cashier_name = d["cashierName"]
      sales_order_payment.credit_card_bank_id = d["creditCardBankId"]
      sales_order_payment.credit_card_number = d["creditCardNumber"]
      sales_order_payment.debit_card_bank_id = d["debitCardBankId"]
      sales_order_payment.debit_card_number = d["debitCardNumber"]
      sales_order_payment.member_id = d["memberId"]
      sales_order_payment.nominal = d["nominal"]
      sales_order_payment.pay_left = d["payLeft"]
      sales_order_payment.payment_date = d["paymentDate"]
      sales_order_payment.payment_number = d["paymentNumber"]
      sales_order_payment.payment_type = d["paymentTtype"]
      sales_order_payment.sales_order_id = d["salesOrderId"]
      sales_order_payment.salesman_id = d["salesmanId"]
      sales_order_payment.voucher_code = d["voucherCode"]
      sales_order_payment.save!
    end
  end
end