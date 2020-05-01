class Wilayah < ActiveRecord::Base
	JOIN = ''
  ORDER = 'wilayahs.id'
  SELECTED = 'wilayahs.*'
  GROUP_BY = 'wilayahs.id'

  before_save :upcase_save
  has_many :provinces

  validates :name, presence: true, :length => {minimum: 3, maximum: 50}, uniqueness: true
  validates :code, presence: true, :length => {minimum: 3, maximum: 50}, uniqueness: true

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
    number = (Wilayah.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:wilayah][:name][0]
    number = (Wilayah.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_wilayah_id(wilayah)
    id = (Wilayah.first(:conditions => "code = '#{wilayah}' or name = '#{wilayah}'", :order => "id DESC").id.to_i rescue 0)
    return id
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name"]
      all.each do |wilayah|
        csv << [wilayah.code, wilayah.name]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name"]
      all.each do |wilayah|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      wilayah = find_by_id(row["id"]) || new
      parameters = ActionController::Parameters.new(row.to_hash)
      wilayah.update(parameters.permit(:code, :name))
      wilayah.save!
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