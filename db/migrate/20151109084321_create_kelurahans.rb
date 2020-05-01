class CreateKelurahans < ActiveRecord::Migration
  def change
    create_table :kelurahans do |t|
    	t.string :code
    	t.string :name
    	t.integer :kelurahan_id
      t.timestamps
    end
  end
end
