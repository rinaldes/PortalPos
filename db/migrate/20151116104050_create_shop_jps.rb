class CreateShopJps < ActiveRecord::Migration
  def change
    create_table :shop_jps do |t|
      t.string :salesman_name
      t.string :day
      t.string :week1
      t.string :week2
      t.string :week3
      t.string :week4
      t.string :route
      t.integer :shop_id
      t.timestamps
    end
  end
end
