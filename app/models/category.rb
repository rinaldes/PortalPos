class Category < ActiveRecord::Base
  #  include Filter
  JOIN = ''
  ORDER = 'categories.id'
  SELECTED = 'categories.*'
  GROUP_BY = 'categories.id'

  before_save :upcase_save
  belongs_to :division
  has_many :brands

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
    number = (Category.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:category][:name][0]
    number = (Category.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_category_id(category)
    id = (Category.first(:conditions => "code = '#{category}' or name = '#{category}'", :order => "id DESC").id.to_i rescue 0)
    return id
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name", "division_code", "division_name"]
      all.each do |category|
        division = category.division
        csv << [category.code, category.name, (division.code rescue nil), (division.name rescue nil)]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name", "division_code", "division_name"]
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      category = find_by_id(row["id"]) || new
      division = Division.find_by_code(row["division_code"].upcase)
      parameters = ActionController::Parameters.new(row.to_hash)
      category.update(parameters.permit(:code, :name).merge(division_id: division.id))
      category.save!
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