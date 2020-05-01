class CreateItemReceiptPayments < ActiveRecord::Migration
  def change
    create_table :item_receipt_payments do |t|
      t.string :account_bank_destination
      t.string :account_bank_source
      t.string :account_branch_destination
      t.string :account_branch_source
      t.string :account_name_destination
      t.string :account_name_source
      t.string :account_number_destination
      t.string :account_number_source
      t.integer :cashier_id
      t.integer :item_receipt_id
      t.float :nominal
      t.float :pay_left
      t.date :payment_date
      t.string :payment_number
      t.integer :payment_type
      t.integer :supplier_id
      t.timestamps
    end
  end
end
