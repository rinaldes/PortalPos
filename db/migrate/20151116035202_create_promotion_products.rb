class CreatePromotionProducts < ActiveRecord::Migration
  def change
    create_table :promotion_products do |t|
      t.string :name
      t.integer :promotion_id
      t.timestamps
    end
  end
end
