class Area < ActiveRecord::Base
  JOIN = ''
  ORDER = 'areas.id'
  SELECTED = 'areas.*'
  GROUP_BY = 'areas.id'

  before_save :upcase_save
  has_many :distributors
  belongs_to :region

  validates :name, presence: true, :length => {:minimum => 3, :maximum => 50}, uniqueness: true
  validates :code, presence: true, :length => {:minimum => 3, :maximum => 50}, uniqueness: true
  validates :region_id, presence: true

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
    number = (Area.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:area][:name][0]
    number = (Area.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_area_id(area)
    id = (Area.first(:conditions => "code = '#{area}' or name = '#{area}'", :order => "id DESC").id.to_i rescue 0)
    return id
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name", "region_code", "region_name"]
      all.each do |area|
        csv << [area.code, area.name, (area.region.code rescue nil), (area.region.name rescue nil)]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name", "region_code", "region_name"]
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      area = find_by_code(row["code"]) || new
      region = Region.find_by_code(row["region_code"])
      parameters = ActionController::Parameters.new(row.to_hash)
      area.update(parameters.permit(:code, :name).merge(:region_id => region.id))
      area.save!
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