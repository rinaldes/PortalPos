class RemakePromotion < ActiveRecord::Migration
  def change
  	drop_table :promotions
    create_table :promotions do |t|
      t.string :code
      t.string :name
      t.date :start
      t.date :end
      t.integer :flag_range
      t.integer :max_apply
      t.integer :min_bruto
      t.integer :bruto_value
      t.integer :multipler_purchase_limit
      t.integer :multipler_getpercent
      t.integer :multipler_getprice
      t.integer :multipler_getquantity
      t.integer :min_price
      t.integer :all_outtype
      t.integer :all_outgroup
      t.integer :all_salesman
      t.integer :all_outlet
      t.integer :all_team
      t.string :flag_multiple
      t.string :coverage_id
      t.timestamps
    end
  end
end
