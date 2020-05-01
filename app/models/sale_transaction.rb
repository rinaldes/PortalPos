class SaleTransaction < ActiveRecord::Base
  has_many :sale_transaction_details, foreign_key: 'transaction_id'
  has_many :retur_orders
  def self.api(params)
    ActiveSupport::JSON.decode(params).each do |d|
      sale_transaction = self.new()
      sale_transaction.credit_card_bank_id = d["creditCardBankId"]
      sale_transaction.credit_card_number = d["creditCardNumber"]
      sale_transaction.debit_card_bank_id = d["debitCardBankId"]
      sale_transaction.debit_card_number = d["debitCardNumber"]
      sale_transaction.discount_nominal = d["discountNominal"]
      sale_transaction.discount_percent = d["discountPercent"]
      sale_transaction.employee_id = d["employeeId"]
      sale_transaction.gross = d["gross"]
      sale_transaction.member_id = d["memberId"]
      sale_transaction.nett = d["nett"]
      sale_transaction.pay_cash = d["payCash"]
      sale_transaction.pay_credit_card = d["payCreditCard"]
      sale_transaction.pay_debit_card = d["payDebitCard"]
      sale_transaction.pay_voucher = d["payVoucher"]
      sale_transaction.transaction_date = d["transactionDate"]
      sale_transaction.transaction_number = d["transactionNumber"]
      sale_transaction.voucher_number = d["voucherNumber"]
      sale_transaction.save!
      sale_transaction.create_details(d['transactionDetails'])
    end
  end

  def create_details(params)
    params.each do |d|
      sale_transaction_detail = sale_transaction_details.new()
      sale_transaction_detail.base_price = d["basePrice"]
      sale_transaction_detail.count = d["count"]
      sale_transaction_detail.discount_nominal = d["discountNominal"]
      sale_transaction_detail.discount_percent = d["discountPercent"]
      sale_transaction_detail.item_id = d["itemId"]
      sale_transaction_detail.promotional_id = d["promotionalId"]
      sale_transaction_detail.retur_quatity = d["returQuatity"]
      sale_transaction_detail.selling_price = d["sellingPrice"]
      sale_transaction_detail.save!
    end if params.present?
  end
end