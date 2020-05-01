class PromotionChangeColumn < ActiveRecord::Migration
  def change
    add_column :promotions, :name, :string
    remove_column :promotions, :sku_id
    remove_column :promotion_products, :name
    add_column :promotion_products, :sku_id, :integer
  end
end
