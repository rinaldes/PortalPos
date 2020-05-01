class CreateSaleTransactions < ActiveRecord::Migration
  def change
    create_table :sale_transactions do |t|
      t.integer :credit_card_bank_id
      t.string :credit_card_number
      t.integer :debit_card_bank_id
      t.string :debit_card_number
      t.float :discount_nominal
      t.float :discount_percent
      t.integer :employee_id
      t.float :gross
      t.integer :member_id
      t.float :nett
      t.float :pay_cash
      t.float :pay_credit_card
      t.float :pay_debit_card
      t.float :pay_voucher
      t.date :transaction_date
      t.string :transaction_number
      t.string :voucher_number
      t.timestamps
    end
  end
end
