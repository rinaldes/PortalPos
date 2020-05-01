class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :code
      t.string :name
      t.integer :used
      t.timestamps
    end
  end
end
