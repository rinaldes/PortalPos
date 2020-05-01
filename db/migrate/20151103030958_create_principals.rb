class CreatePrincipals < ActiveRecord::Migration
  def change
    create_table :principals do |t|
    	t.string :code
    	t.string :name
    	t.string :address
    	t.string :no_telp1
    	t.string :no_telp2
    	t.string :fax
    	t.string :email
      t.timestamps
    end
  end
end
