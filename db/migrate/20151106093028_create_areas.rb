class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
    	t.string :code
    	t.string :name
    	t.integer :region_id
      t.timestamps
    end
  end
end
