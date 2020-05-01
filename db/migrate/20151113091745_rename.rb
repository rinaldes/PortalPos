class Rename < ActiveRecord::Migration
  def change
  	rename_column :discount_products, :plu_id, :sku_id
  end
end
