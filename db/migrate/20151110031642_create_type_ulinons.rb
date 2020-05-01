class CreateTypeUlinons < ActiveRecord::Migration
  def change
    create_table :type_ulinons do |t|
      t.string :code
      t.string :name
      t.timestamps
    end
  end
end
