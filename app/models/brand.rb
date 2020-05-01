class Brand < ActiveRecord::Base
	#  include Filter
  JOIN = ''
  ORDER = 'brands.id'
  SELECTED = 'brands.*'
  GROUP_BY = 'brands.id'

  before_save :upcase_save
  belongs_to :category
  has_many :skus

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
    number = (Brand.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:brand][:name][0]
    number = (Brand.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_brand_id(brand)
    id = (Brand.first(:conditions => "code = '#{brand}' or name = '#{brand}'", :order => "id DESC").id.to_i rescue 0)
    return id
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name", "category_code", "category_name", "division_code", "division_name"]
      all.each do |brand|
        csv << [brand.code, brand.name, brand.category.code, brand.category.name, brand.category.division.code, brand.category.division.name]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["name", "category_name"]
      all.each do |brand|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      brand = find_by_id(row["code"]) || new
      category = Category.find_by_name(row["category_name"].upcase)
      parameters = ActionController::Parameters.new(row.to_hash)
      brand.update(parameters.permit(:code, :name).merge(category_id: category.id))
      brand.save
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