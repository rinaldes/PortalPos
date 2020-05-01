class CreateKecamatans < ActiveRecord::Migration
  def change
    create_table :kecamatans do |t|
    	t.string :code
    	t.string :name
    	t.integer :city_id
      t.timestamps
    end
  end
end
