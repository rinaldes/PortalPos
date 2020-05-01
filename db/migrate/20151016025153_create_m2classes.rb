class CreateM2classes < ActiveRecord::Migration
  def change
    create_table :m2classes do |t|
    	t.string :code
      t.string :name
      t.integer :mclass_id
      t.timestamps
    end
  end
end
