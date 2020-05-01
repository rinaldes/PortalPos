class CreateReturToSuppliers < ActiveRecord::Migration
  def change
    create_table :retur_to_suppliers do |t|
      t.integer :receipt_id
      t.string :note
      t.integer :supplier_id
      t.float :total
      t.date :transaction_date
      t.string :transaction_id
      t.integer :user_id
      t.timestamps
    end
  end
end
