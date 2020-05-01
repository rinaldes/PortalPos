class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :code
      t.string :name
      t.time :time
      t.timestamps
    end
  end
end
