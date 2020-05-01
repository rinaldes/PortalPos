class CreateSaleTransactionDetails < ActiveRecord::Migration
  def change
    create_table :sale_transaction_details do |t|
      t.float :base_price
      t.integer :count
      t.float :discount_nominal
      t.float :discount_percent
      t.integer :item_id
      t.integer :promotional_id
      t.integer :retur_quatity
      t.float :selling_price
      t.integer :transaction_id
      t.timestamps
    end
  end
end
