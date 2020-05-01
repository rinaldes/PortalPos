class AddTypeForCashInCashOut < ActiveRecord::Migration
  def change
    add_column :cash_in_cash_outs, :tipe, :integer
  end
end