class Region < ActiveRecord::Base
	#  include Filter
  JOIN = ''
  ORDER = 'regions.id'
  SELECTED = 'regions.*'
  GROUP_BY = 'regions.id'

  before_save :upcase_save
  has_many :areas

  validates :name, :presence => {:message => 'harus diisi'}, :length => {:minimum => 3, :maximum => 50, :message => 'minimal 3 karakter'}, :uniqueness => {:message => 'sudah dipakai'}
  
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
    number = (Region.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:region][:name][0]
    number = (Region.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_region_id(region)
    id = (Region.first(:conditions => "code = '#{region}' or name = '#{region}'", :order => "id DESC").id.to_i rescue 0)
    return id
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name"]
      all.each do |region|
        csv << [region.code, region.name]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["name"]
      all.each do |region|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      region = find_by_id(row["id"]) || new
      parameters = ActionController::Parameters.new(row.to_hash)
      region.update(parameters.permit(:code, :name))
      region.save!
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
