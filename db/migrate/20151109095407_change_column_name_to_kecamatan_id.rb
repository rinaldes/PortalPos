class ChangeColumnNameToKecamatanId < ActiveRecord::Migration
  def change
  	rename_column :kelurahans, :kelurahan_id, :kecamatan_id
  end
end
