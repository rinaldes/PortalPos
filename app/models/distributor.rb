class Distributor < ActiveRecord::Base
	JOIN = ''
  ORDER = 'distributors.id'
  SELECTED = 'distributors.*'
  GROUP_BY = 'distributors.id'

  before_save :upcase_save
  has_many :distriks
  #has_many :shops
  belongs_to :area

  validates :name, :presence => true, :length => {:minimum => 3, :maximum => 50}, :uniqueness => true
  validates :code, :presence => true, :length => {:minimum => 3, :maximum => 50}, :uniqueness => true
  validates :address, :presence => true
  validates :telp1, :presence => true
  validates :email, :presence => true
  validates :area_id, :presence => true

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
    number = (Distributor.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:distributor][:name][0]
    number = (Distributor.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_distributor_id(distributor)
    id = (Distributor.first(:conditions => "code = '#{distributor}' or name = '#{distributor}'", :order => "id DESC").id.to_i rescue 0)
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
      csv << ["code", "name", "area_code", "area_name", "region_code", "region_name", "address", "telp1", "telp2", "email", "fax"]
      all.each do |distributor|
        csv << [distributor.code, distributor.name, distributor.area.code, distributor.area.name, distributor.area.region.code, distributor.area.region.name, distributor.address, distributor.telp1, distributor.telp2, distributor.email, distributor.fax]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["name", "area_name"]
      all.each do |distributor|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      distributor = find_by_id(row["id"]) || new
      area = Area.find_by_name(row["area_name"].upcase)
      parameters = ActionController::Parameters.new(row.to_hash)
      distributor.update(parameters.permit(:name, :address, :telp2, :telp1, :email, :fax).merge(:code => (('%03d' % ((Distributor.last.code.to_i rescue 0)+1)))).merge(:area_id => area.id))
      distributor.save!
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
