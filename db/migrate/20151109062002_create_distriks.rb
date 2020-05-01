class CreateDistriks < ActiveRecord::Migration
  def change
    create_table :distriks do |t|
      t.string :code
      t.string :name
      t.integer :distributor_id
      t.timestamps
    end
  end
end
