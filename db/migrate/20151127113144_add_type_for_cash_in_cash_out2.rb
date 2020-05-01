class AddTypeForCashInCashOut2 < ActiveRecord::Migration
  def change
  	remove_column :cash_in_cash_outs, :type
  end
end
