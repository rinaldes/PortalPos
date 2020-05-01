class CreateM3classes < ActiveRecord::Migration
  def change
    create_table :m3classes do |t|
    	t.string :code
      t.string :name
      t.integer :m2class_id
      t.timestamps
    end
  end
end
