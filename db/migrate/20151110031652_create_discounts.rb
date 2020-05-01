class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.string :code
      t.string :name
      t.date :start
      t.date :end
      t.string :pilihan
      t.string :multi
      t.string :flag
      t.integer :batas
      t.integer :multi_persen
      t.integer :multi_nilai
      t.string :cakupan
      t.timestamps
    end
  end
end
