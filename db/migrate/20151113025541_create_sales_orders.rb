class CreateSalesOrders < ActiveRecord::Migration
  def change
    create_table :sales_orders do |t|
      t.integer :cashier_id
      t.integer :delivered
      t.date :delivery_date
      t.string :delivery_instruction
      t.float :discount_nominal
      t.string :dispatched_by
      t.date :due_date
      t.float :fat
      t.float :gross
      t.integer :member_id
      t.float :nett
      t.string :ordered_by
      t.float :paid
      t.integer :pengirim_id
      t.integer :promotion_id
      t.string :remarks
      t.integer :retur
      t.date :sales_order_date
      t.integer :salesman_id
      t.string :so_number
      t.integer :supervisor_id
      t.float :tax
      t.timestamps
    end
  end
end
