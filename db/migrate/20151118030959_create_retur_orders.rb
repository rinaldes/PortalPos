class CreateReturOrders < ActiveRecord::Migration
  def change
    create_table :retur_orders do |t|
      t.string :description
      t.integer :member_id
      t.integer :sales_order_id
      t.float :total
      t.date :transaction_date
      t.string :transaction_id
      t.integer :user_id
      t.timestamps
    end
  end
end
