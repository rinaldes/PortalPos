class CreateDiscountHargas < ActiveRecord::Migration
  def change
    create_table :discount_hargas do |t|
      t.string :code
      t.integer :min
      t.integer :max
      t.string :jenis
      t.float :percent
      t.float :price
      t.timestamps
    end
  end
end
