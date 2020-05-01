class CreateReturOrderDetails < ActiveRecord::Migration
  def change
    create_table :retur_order_details do |t|
      t.float :base_price
      t.integer :item_id
      t.integer :quantity
      t.integer :retur_order_id
      t.float :selling_price
      t.timestamps
    end
  end
end
