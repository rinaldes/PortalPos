class AddCashierNameToSalesOrderPayment < ActiveRecord::Migration
  def change
    add_column :sales_order_payments, :cashier_name, :string
  end
end
