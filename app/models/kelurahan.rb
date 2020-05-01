class Kelurahan < ActiveRecord::Base
	JOIN = ''
  ORDER = 'kelurahans.id'
  SELECTED = 'kelurahans.*'
  GROUP_BY = 'kelurahans.id'

  before_save :upcase_save
  belongs_to :kecamatan
  has_many :shops

  validates :name, presence: true, :length => {minimum: 3, maximum: 50}, uniqueness: true
  validates :code, presence: true, :length => {minimum: 2, maximum: 50}

  scope :search, lambda {|search|{
    :order => "code ASC",
    :conditions => [
      'code LIKE ? OR name LIKE ? OR address LIKE ? OR no_telp1 LIKE ? OR no_telp2 LIKE ? OR fax LIKE ? OR email LIKE ?',
      "%#{search.first}%", "%#{search.first}%"
    ]
  }}

  def upcase_save
    self.name = name.upcase rescue nil
  end
  
  def self.number(params)
    number = (Kelurahan.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:kelurahan][:name][0]
    number = (Kelurahan.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_kelurahan_id(kelurahan)
    id = (Kelurahan.first(:conditions => "code = '#{kelurahan}' or name = '#{kelurahan}'", :order => "id DESC").id.to_i rescue 0)
    return id
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name", "kecamatan_code", "kecamatan_name", "city_code", "city_name", "province_code", "province_name", "region_code", "region_name"]
      all.each do |kelurahan|
        kecamatan = kelurahan.kecamatan
        city = kecamatan.city
        province = city.province
        wilayah = province.wilayah
        csv << [kelurahan.code, kelurahan.name, kecamatan.code, kecamatan.name, city.code, city.name, province.code, province.name, wilayah.code, wilayah.name]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << %w(province_code city_code kecamatan_code code name)
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      kelurahan = find_by_id(row["id"]) || new
      kecamatan = Kecamatan.find_by_code(row["kecamatan_code"])
      parameters = ActionController::Parameters.new(row.to_hash)
      kelurahan.update(parameters.permit(:code, :name).merge(kecamatan_id: (kecamatan.id rescue nil)))
      kelurahan.save validates: false
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Csv.new(file.path, nil, :ignore)
    when ".xls" then Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end