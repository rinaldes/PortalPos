class CreateCashInCashOuts < ActiveRecord::Migration
  def change
	create_table :cash_in_cash_outs do |t|
    t.float :cash_value
    t.string :description
    t.integer :jurnal_id
    t.integer :number_id
    t.date :transaction_date
    t.string :transaction_id
	  t.integer :type
	  t.timestamps
	end
  end
end
