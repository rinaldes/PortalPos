class Sku < ActiveRecord::Base
	#  include Filter
  JOIN = ''
  ORDER = 'skus.id'
  SELECTED = 'skus.*'
  GROUP_BY = 'skus.id'

  before_save :upcase_save
  belongs_to :brand
  has_many :plus
  has_many :promotion_products

  validates :name, :presence => {:message => 'harus diisi'}, :length => {:minimum => 3, :maximum => 50, :message => 'minimal 3 karakter'}, :uniqueness => {:message => 'sudah dipakai'}
  
  scope :search, lambda {|search|{
    :order => "code ASC",
    :conditions => [
      'code LIKE ? OR name LIKE ?',
      "%#{search.first}%", "%#{search.first}%"
    ]
  }}

  def upcase_save
    self.name = name.upcase rescue nil
  end

  def self.number(params)
    number = (Sku.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:sku][:name][0]
    number = (Sku.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_sku_id(sku)
    id = (Sku.first(:conditions => "code = '#{sku}' or name = '#{sku}'", :order => "id DESC").id.to_i rescue 0)
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
      csv << ["code", "name", "brand_name", "division_name"]
      all.each do |sku|
        csv << [sku.code, sku.name, sku.brand.name, sku.brand.category.division.name]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["name", "brand_name"]
      all.each do |sku|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      sku = find_by_id(row["id"]) || new
      plu = Brand.find_by_name(row["brand_name"].upcase)
      parameters = ActionController::Parameters.new(row.to_hash)
      sku.update(parameters.permit(:name).merge(:code => (('%03d' % ((Sku.last.code.to_i rescue 0)+1)))).merge(:brand_id => plu.id))
      sku.save!
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
