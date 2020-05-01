class CreateShopAddresses < ActiveRecord::Migration
  def change
    create_table :shop_addresses do |t|
      t.string :contact_person
      t.string :position
      t.string :phone1
      t.string :phone2
      t.date :birthday
      t.string :email
      t.integer :shop_id
      t.timestamps
    end
  end
end
