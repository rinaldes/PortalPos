class CreateM4classes < ActiveRecord::Migration
  def change
    create_table :m4classes do |t|
    	t.string :code
      t.string :name
      t.integer :m3class_id
      t.timestamps
    end
  end
end
