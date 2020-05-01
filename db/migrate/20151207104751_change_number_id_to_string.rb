class ChangeNumberIdToString < ActiveRecord::Migration
  def change
    change_column :cash_in_cash_outs, :number_id, :string
  end
end
