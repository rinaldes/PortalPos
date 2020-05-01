class CreateBeats < ActiveRecord::Migration
  def change
    create_table :beats do |t|
      t.string :code
      t.string :name
      t.integer :distrik_id
      t.timestamps
    end
  end
end
