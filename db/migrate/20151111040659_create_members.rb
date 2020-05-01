class CreateMembers < ActiveRecord::Migration
  def change
    drop_table :members
    create_table :members do |t|
      t.integer :active
      t.string :address_home
      t.string :barcode
      t.date :birth_date
      t.string :birth_place
      t.string :code
      t.float :credit_limit
      t.float :discountpercent
      t.string :email
      t.string :foto
      t.string :noidentitas
      t.integer :identity_type
      t.integer :jenis
      t.integer :member_category_id
      t.integer :member_group_id
      t.string :mobile
      t.string :name
      t.string :npwp_alamat
      t.string :npwp_nama
      t.string :npwp_no
      t.string :occupation
      t.string :phone
      t.integer :pin
      t.integer :point_used
      t.date :registration_date
      t.string :religion
      t.string :sex
      t.integer :status
      t.integer :term_of_payment
      t.timestamps
    end
  end
end
