class DiscountIdBuatChildnya < ActiveRecord::Migration
  def change
    add_column :discount_hargas, :discount_id, :integer
    add_column :discount_products, :discount_id, :integer
  end
end
