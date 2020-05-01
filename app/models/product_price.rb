class ProductPrice < ActiveRecord::Base
  JOIN = ''
  ORDER = 'product_prices.id'
  SELECTED = 'product_prices.*'
  GROUP_BY = 'product_prices.id'

  before_save :upcase_save
 # belongs_to :price_group

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
    number = (ProductPrice.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:product_price][:name][0]
    number = (ProductPrice.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_product_price_id(product_price)
    id = (ProductPrice.first(:conditions => "code = '#{product_price}' or name = '#{product_price}'", :order => "id DESC").id.to_i rescue 0)
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
      csv << ["code", "name", "h_jual_kecil", "h_jual_menengah", "h_jual_besar"]
      all.each do |product_price|
        csv << [product_price.code, product_price.name, product_price.h_jual_kecil, product_price.h_jual_menengah, product_price.h_jual_besar]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["name", "h_jual_kecil", "h_jual_menengah", "h_jual_besar"]
      all.each do |product_price|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      product_price = find_by_id(row["id"]) || new
      parameters = ActionController::Parameters.new(row.to_hash)
      product_price.update(parameters.permit(:name).merge(:code => (('%03d' % ((ProductPrice.last.code.to_i rescue 0)+1)))))
      product_price.save!
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