class AddCashierNameToSalesOrder < ActiveRecord::Migration
  def change
    add_column :sales_orders, :cashier_name, :string
  end
end
