class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
    	t.string :code
    	t.string :name
    	t.string :principal_id
      t.timestamps
    end
  end
end
