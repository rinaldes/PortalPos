class ShopUpgrade < ActiveRecord::Migration
  def change
    drop_table :shops
  	create_table :shops do |t|
      t.string :code
      t.string :name
      t.string :national_id
      t.string :address
      t.string :barcode
      t.string :phone1
      t.string :phone2
      t.string :status
      t.string :fax
      t.string :email
      t.string :postal_code
      t.string :outlet_parent

      t.string :discount_group_id
      t.string :location
      t.string :outlet_type
      t.string :outlet_group_id
      t.string :market_code
      t.string :classification
      t.string :industri_code
      t.string :credit_limit
      t.string :TOP
      t.string :Price_group
      t.string :Outlet_photo
      t.string :signature_photo
      t.string :longitude
      t.string :latitude

      t.string :tax_name
      t.string :tax_address
      t.string :tax_tin
      t.string :tax_invoice
      t.string :tax_city

      t.string :shipping_address
      t.string :shipping_city
      t.string :shipping_phone
      t.string :billing_address
      t.string :billing_city
      t.string :billing_phone

      t.string :province_id
      t.string :city_id
      t.string :subdistrict
      t.string :village
      t.string :distributor
      t.string :district_id
      t.string :beat_id
      t.string :subbeat_id
      
      t.timestamps
    end
  end
end
