class Shop < ActiveRecord::Base
	JOIN = ''
  ORDER = 'shops.id'
  SELECTED = 'shops.*'
  GROUP_BY = 'shops.id'

  before_save :upcase_save
  belongs_to :kelurahan
  belongs_to :subbeat

  validates :name, presence: true, :length => {:minimum => 3, :maximum => 50}, uniqueness: true
  validates :code, presence: true, :length => {:minimum => 3, :maximum => 50}, uniqueness: true
  validates :address, presence: true
  validates :telp, presence: true
  validates :email, presence: true
  validates :npwp, presence: true

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
    number = (Shop.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:shop][:name][0]
    number = (Shop.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_shop_id(shop)
    id = (Shop.first(:conditions => "code = '#{shop}' or name = '#{shop}'", :order => "id DESC").id.to_i rescue 0)
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
      csv << ["code", "name", "address", "city_name", "distributor_name", "area_name", "region_name", "telp", "fax", "email", "npwp"]
      all.each do |shop|
        csv << [shop.code, shop.name, shop.city.name, shop.address, shop.distributor.name, shop.distributor.area.name, shop.distributor.area.region.name, shop.telp, shop.fax, shop.email, shop.npwp]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["name", "address", "city_name", "distributor_name", "telp", "fax", "email", "npwp"]
      all.each do |shop|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      shop = find_by_id(row["id"]) || new
      distributor = Distributor.find_by_name(row["distruibutor_name"].upcase)
      city = City.find_by_name(row["city_name"].upcase)
      parameters = ActionController::Parameters.new(row.to_hash)
      shop.update(parameters.permit(:name, :address, :city_name, :distributor_name, :telp, :fax, :email, :npwp).merge(:code => (('%03d' % ((Shop.last.code.to_i rescue 0)+1)))).merge(:distributor_id => distributor.id).merge(:city_id => city.id))
      shop.save!
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
