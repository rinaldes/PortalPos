class PromotionProductChangeColumn < ActiveRecord::Migration
  def change
    remove_column :promotions, :name
    add_column :promotions, :sku_id, :integer
  end
end
