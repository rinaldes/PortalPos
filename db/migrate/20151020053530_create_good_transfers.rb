class CreateGoodTransfers < ActiveRecord::Migration
  def change
    create_table :good_transfers do |t|
    	t.integer :origin_branch_id
      t.integer :destination_branch_id
      t.string :status
      t.date :transfer_date
      t.integer :receiver_id
      t.date :received_date
      t.string :code
      t.integer :user_id
      t.timestamps
    end
    add_index :good_transfers, :origin_branch_id
    add_index :good_transfers, :destination_branch_id
    add_index :good_transfers, :status
    add_index :good_transfers, :transfer_date
    add_index :good_transfers, :receiver_id
    add_index :good_transfers, :received_date
    add_index :good_transfers, :code
    add_index :good_transfers, :user_id
  end
end
