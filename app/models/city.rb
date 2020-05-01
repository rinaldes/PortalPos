class City < ActiveRecord::Base
  ORDER = 'cities.id'
  SELECTED = 'cities.*'
  GROUP_BY = 'cities.id'

  before_save :upcase_save
  has_many :kecamatans
  #has_many :shops
  belongs_to :province

  validates :name, presence: true, :length => {minimum: 3, maximum: 50}, uniqueness: true
  validates :code, presence: true, :length => {minimum: 2, maximum: 50}
  validates :province_id, presence: true
  validate :uniq_code_per_province

  scope :search, lambda {|search|{
    :order => "code ASC",
    :conditions => [
      'code LIKE ? OR name LIKE ? OR address LIKE ? OR no_telp1 LIKE ? OR no_telp2 LIKE ? OR fax LIKE ? OR email LIKE ?',
      "%#{search.first}%", "%#{search.first}%"
    ]
  }}

  def uniq_code_per_province
    errors.add(:code, I18n.t(:must_be_uniq_per_province)) if City.find_by_code_and_province_id code, province_id
  end

  def upcase_save
    self.name = name.upcase rescue nil
  end
  
  def self.number(params)
    number = (City.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:city][:name][0]
    number = (City.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_city_id(city)
    id = (City.first(:conditions => "code = '#{city}' or name = '#{city}'", :order => "id DESC").id.to_i rescue 0)
    return id
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name", "province_code", "province_name", "region_code", "region_name"]
      all.each do |city|
        csv << [city.code, city.name, city.province.code, city.province.name, city.province.wilayah.code, city.province.wilayah.name]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["province_code", "code", "name"]
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      city = find_by_id(row["id"]) || new
      province = Province.find_by_code(row["province_code"])
      parameters = ActionController::Parameters.new(row.to_hash)
      city.update(parameters.permit(:code, :name).merge(province_id: (province.id rescue nil)))
      city.save!
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