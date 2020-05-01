class CreateAppsUpdaters < ActiveRecord::Migration
  def change
    create_table :apps_updaters do |t|
    	t.string :code
    	t.string :name
    	t.date :date
      t.timestamps
    end
  end
end
