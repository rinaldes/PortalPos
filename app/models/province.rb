class Province < ActiveRecord::Base
	JOIN = ''
  ORDER = 'provinces.id'
  SELECTED = 'provinces.*'
  GROUP_BY = 'provinces.id'

  before_save :upcase_save
  has_many :cities
  belongs_to :wilayah

  validates :name, presence: true, :length => {minimum: 3, maximum: 50}, uniqueness: true
  validates :code, presence: true, :length => {minimum: 2, maximum: 50}, uniqueness: true
  validates :wilayah_id, presence: true

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
    number = (Province.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:province][:name][0]
    number = (Province.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_province_id(province)
    id = (Province.first(:conditions => "code = '#{province}' or name = '#{province}'", :order => "id DESC").id.to_i rescue 0)
    return id
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name", "region_code", "region_name"]
      all.each do |province|
        csv << [province.code, province.name, province.wilayah.code, province.wilayah.name]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name", "zone_code", "zone_name"]
      all.each do |province|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      province = find_by_id(row["id"]) || new
      wilayah = Wilayah.find_by_name(row["zone_name"])
      parameters = ActionController::Parameters.new(row.to_hash)
      province.update(parameters.permit(:code, :name).merge(:wilayah_id => (wilayah.id rescue nil)))
      province.save!
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