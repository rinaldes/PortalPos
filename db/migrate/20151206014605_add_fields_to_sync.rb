class AddFieldsToSync < ActiveRecord::Migration
  def change
    add_column :histories, :shop_id, :integer
    add_column :histories, :start_at, :datetime
    add_column :histories, :end_at, :datetime
    add_column :histories, :counter, :integer
  end
end
