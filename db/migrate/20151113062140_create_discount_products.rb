class CreateDiscountProducts < ActiveRecord::Migration
  def change
    create_table :discount_products do |t|
      t.string :plu_id
      t.integer :min
      t.integer :max
      t.float :percent
      t.timestamps
    end
  end
end
