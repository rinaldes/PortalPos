class CreatePlus < ActiveRecord::Migration
  def change
    create_table :plus do |t|
    	t.string :code
    	t.integer :sku_id
    	t.integer :h_jual
    	t.integer :h_beli
    	t.string :satuan
      t.timestamps
    end
  end
end
