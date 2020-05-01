class AddCashierNameToItemReceiptPayment < ActiveRecord::Migration
  def change
    add_column :item_receipt_payments, :cashier_name, :string
  end
end
