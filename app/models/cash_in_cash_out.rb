class CashInCashOut < ActiveRecord::Base
  def self.api(params)
    ActiveSupport::JSON.decode(params).each do |d|
      cash_in_cash_out = self.new
      cash_in_cash_out.cash_value = d["cashValue"]
      cash_in_cash_out.description = d["description"]
      cash_in_cash_out.jurnal_id = d["jurnalId"]
      cash_in_cash_out.number_id = d["numberId"]
      cash_in_cash_out.transaction_date = Time.now
      cash_in_cash_out.transaction_id = d["transactionId"]
      cash_in_cash_out.tipe = d["type"]
      cash_in_cash_out.save!
    end
  end
end