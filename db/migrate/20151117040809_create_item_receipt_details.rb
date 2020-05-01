class CreateItemReceiptDetails < ActiveRecord::Migration
  def change
    create_table :item_receipt_details do |t|
      t.integer :item_id
      t.integer :item_receipt_id
      t.float :price
      t.integer :receipt_count
      t.timestamps
    end
  end
end
