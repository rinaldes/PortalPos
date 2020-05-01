class AddRenameRoleUser < ActiveRecord::Migration
  def change
    add_column :features, :role_id, :integer
  end
end
