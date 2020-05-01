class CreateSalesOrderPayments < ActiveRecord::Migration
  def change
    create_table :sales_order_payments do |t|
      t.string :account_bank_destination
      t.string :account_bank_source
      t.string :account_branch_destination
      t.string :account_branch_source
      t.string :account_name_destination
      t.string :account_name_source
      t.string :account_number_destination
      t.string :account_number_source
      t.integer :cashier_id
      t.integer :credit_card_bank_id
      t.string :credit_card_number
      t.integer :debit_card_bank_id
      t.string :debit_card_number
      t.integer :member_id
      t.float :nominal
      t.float :pay_left
      t.date :payment_date
      t.string :payment_number
      t.integer :payment_type
      t.integer :sales_order_id
      t.integer :salesman_id
      t.string :voucher_code
      t.timestamps
    end
  end
end
