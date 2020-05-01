class Plu < ActiveRecord::Base
	#  include Filter
  JOIN = ''
  ORDER = 'plus.id'
  SELECTED = 'plus.*'
  GROUP_BY = 'plus.id'

  belongs_to :sku

  #validates :name, :presence => {:message => 'harus diisi'}, :length => {:minimum => 3, :maximum => 50, :message => 'minimal 3 karakter'}, :uniqueness => {:message => 'sudah dipakai'}
  
  scope :search, lambda {|search|{
    :order => "code ASC",
    :conditions => [
      'code LIKE ?',
      "%#{search.first}%"
    ]
  }}

  def self.number(params)
    number = (Plu.first(:conditions => "code like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end
=begin
  def self.create_number(params)
    init = params[:plu][:name][0]
    number = (Plu.first(:conditions => "code like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end
=end
  def self.get_plu_id(plu)
    id = (Plu.first(:conditions => "code = '#{plu}'", :order => "id DESC").id.to_i rescue 0)
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
      csv << ["code", "sku_code", "sku_name", "division_name", "category_name", "brand_name", "h_jual", "h_beli", "satuan" ]
      all.each do |plu|
        csv << [plu.code, plu.sku.code, plu.sku.name, plu.sku.brand.category.division.name, plu.sku.brand.category.name, plu.sku.brand.name, plu.h_jual, plu.h_beli, plu.satuan]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["sku_name", "h_jual", "h_beli", "satuan"]
      all.each do |plu|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      plu = find_by_id(row["id"]) || new
      brand = Category.find_by_name(row["brand_name"].upcase)
      parameters = ActionController::Parameters.new(row.to_hash)
      plu.update(parameters.permit(:name, :h_jual, :h_beli, :satuan).merge(:code => (('%03d' % ((Colour.last.code.to_i rescue 0)+1)))).merge(:brand_id => brand.id))
      plu.save!
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
