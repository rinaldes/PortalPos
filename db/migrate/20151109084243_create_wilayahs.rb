class CreateWilayahs < ActiveRecord::Migration
  def change
    create_table :wilayahs do |t|
    	t.string :code
    	t.string :name
      t.timestamps
    end
  end
end
