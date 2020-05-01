class AddParentIdToTypes < ActiveRecord::Migration
  def change
    add_column :types, :parent_id, :integer
  end
end
