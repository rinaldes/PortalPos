class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
    	t.string :code
    	t.string :name
    	t.string :division_id
      t.timestamps
    end
  end
end
