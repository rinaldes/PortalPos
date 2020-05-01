class Distrik < ActiveRecord::Base
	JOIN = ''
  ORDER = 'distriks.id'
  SELECTED = 'distriks.*'
  GROUP_BY = 'distriks.id'

  before_save :upcase_save
  has_many :beats
  belongs_to :distributor

  validates :name, presence: true, length: {minimum: 3, maximum: 50}, uniqueness: true
  validates :code, presence: true, length: {minimum: 3, maximum: 50}, uniqueness: true
  validates :distributor_id, presence: true

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
    number = (Distrik.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:distrik][:name][0]
    number = (Distrik.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_distrik_id(distrik)
    id = (Distrik.first(:conditions => "code = '#{distrik}' or name = '#{distrik}'", :order => "id DESC").id.to_i rescue 0)
    return id
  end

  def manage_code
    if  self.new_record?
      if self.class.unscoped.available_data.present?
        (('%03d' % ((self.class.unscoped.available_data.order("id ASC").last.code.to_i rescue 0))))
      else
        (('%03d' % ((self.class.order("code ASC").last.code.to_i rescue 0)+1)))
      end
    else
      self.code
    end
  end
  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name","distributor_code", "distributor_name"]
      all.each do |distrik|
        csv << [distrik.code, distrik.name, distrik.distributor.code, distrik.distributor.name]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["name", "distributor_name"]
      all.each do |distrik|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      distrik = find_by_id(row["id"]) || new
      distributor = Distributor.find_by_name(row["distributor_name"].upcase)
      parameters = ActionController::Parameters.new(row.to_hash)
      distrik.update(parameters.permit(:name).merge(:code => (('%03d' % ((Colour.last.code.to_i rescue 0)+1)))).merge(:distributor_id => distributor.id))
      distrik.save!
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
