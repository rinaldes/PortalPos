class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :code
      t.string :name
      t.string :status
      t.timestamps
    end
  end
end
