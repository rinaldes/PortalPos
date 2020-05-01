class ShopUpgradeAgain < ActiveRecord::Migration
  def change
    drop_table :shops
    create_table :shops do |t|
      t.string :code
      t.string :name
      t.string :address
      t.string :telp
      t.string :fax
      t.string :email
      t.string :npwp
      t.integer :kelurahan_id
      t.integer :subbeat_id
      t.timestamps
    end
  end
end
