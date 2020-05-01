class CreateProductPrices < ActiveRecord::Migration
  def change
    create_table :product_prices do |t|
      t.string :code
      t.string :name
      t.integer :h_jual_kecil
      t.integer :h_jual_menengah
      t.integer :h_jual_besar
      t.integer :price_group_id
      t.timestamps
    end
  end
end
