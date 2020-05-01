class CreateItemReceipts < ActiveRecord::Migration
  def change
    create_table :item_receipts do |t|
      t.string :description
      t.float :discountNominal
      t.date :due_date
      t.integer :employee_id
      t.float :nett
      t.integer :paid
      t.integer :payment_type
      t.string :po_number
      t.date :receipt_date
      t.string :receipt_number
      t.string :receiver_name
      t.integer :retur
      t.integer :supplier_id
      t.float :tax
      t.timestamps
    end
  end
end
