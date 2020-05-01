class License < ActiveRecord::Migration
  def change
    add_column :licenses, :jumlah, :integer
  end
end