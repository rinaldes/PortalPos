class CreateSubbeats < ActiveRecord::Migration
  def change
    create_table :subbeats do |t|
    	t.string :code
    	t.string :name
    	t.integer :beat_id
      t.timestamps
    end
  end
end
