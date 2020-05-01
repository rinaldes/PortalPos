class ChangeColumnDivisionsId < ActiveRecord::Migration
  def change  	
  	change_column :categories, :division_id, 'integer USING CAST(division_id AS integer)'
  end
end
