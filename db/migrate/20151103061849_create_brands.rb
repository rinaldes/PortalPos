class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
    	t.string :code
    	t.string :name
    	t.integer :category_id
      t.timestamps
    end
  end
end
