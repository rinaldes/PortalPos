class CreateStockOps < ActiveRecord::Migration
  def change
    create_table :stock_ops do |t|
      t.integer :approved
      t.date :approved_date
      t.string :description
      t.date :transaction_date
      t.string :transaction_id
      t.integer :user_id
      t.timestamps
    end
  end
end
