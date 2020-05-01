class ChangeColumnTypePrincipalsId < ActiveRecord::Migration
  def change
  	change_column :divisions, :principal_id, 'integer USING CAST(principal_id AS integer)'
  end
end
