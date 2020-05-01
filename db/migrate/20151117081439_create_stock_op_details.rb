class CreateStockOpDetails < ActiveRecord::Migration
  def change
    create_table :stock_op_details do |t|
      t.integer :actual_quantity
      t.integer :item_id
      t.string :note
      t.integer :stok_op_id
      t.integer :virtual_quantity
      t.timestamps
    end
  end
end
