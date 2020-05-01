class CreateReturToSupplierDetails < ActiveRecord::Migration
  def change
    create_table :retur_to_supplier_details do |t|
      t.float :price
      t.integer :item_id
      t.integer :quantity
      t.integer :retur_to_supplier_id
      t.integer :user_id
      t.timestamps
    end
  end
end
