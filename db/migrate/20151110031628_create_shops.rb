class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
    	t.string :code
    	t.string :name
      t.string :address
      t.string :telp
      t.string :fax
      t.string :email
      t.string :npwp
      t.integer :city_id
    	t.integer :distributor_id
      t.timestamps
    end
  end
end
