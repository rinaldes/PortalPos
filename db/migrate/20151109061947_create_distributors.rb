class CreateDistributors < ActiveRecord::Migration
  def change
    create_table :distributors do |t|
    	t.string :code
      t.string :name
      t.string :address
      t.string :telp1
      t.string :telp2
      t.string :email
    	t.string :fax
    	t.integer :area_id
      t.timestamps
    end
  end
end
