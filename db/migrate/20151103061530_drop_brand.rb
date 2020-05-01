class DropBrand < ActiveRecord::Migration
  def change
  	drop_table :brands
  end
end
