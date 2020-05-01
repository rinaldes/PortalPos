class DepartmentParentId < ActiveRecord::Migration
  def change
  	add_column :departments, :parent_id, :integer
  end
end
