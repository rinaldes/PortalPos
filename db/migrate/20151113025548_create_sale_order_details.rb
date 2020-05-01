class CreateSaleOrderDetails < ActiveRecord::Migration
  def change
    create_table :sale_order_details do |t|
      t.float :base_price
      t.integer :count
      t.float :discount_nominal
      t.float :discount_percent
      t.integer :item_id
      t.integer :promotion_id
      t.integer :retur_quantity
      t.integer :sales_order_id
      t.float :selling_price
      t.timestamps
    end
  end
end
