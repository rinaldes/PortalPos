class AddColumnNoSuratJalan < ActiveRecord::Migration
  def change
  	add_column :good_transfers, :no_surat_jalan, :string
  end
end
