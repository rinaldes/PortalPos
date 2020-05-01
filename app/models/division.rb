class Division < ActiveRecord::Base
  #  include Filter
  JOIN = ''
  ORDER = 'divisions.id'
  SELECTED = 'divisions.*'
  GROUP_BY = 'divisions.id'

  before_save :upcase_save
  belongs_to :principal
  has_many :categories

  validates :name, presence: true, length: {minimum: 3, maximum: 50}, uniqueness: true
  validates :code, presence: true, length: {minimum: 3, maximum: 50}, uniqueness: true
  validates :principal_id, presence: true

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
    number = (Division.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:division][:name][0]
    number = (Division.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_division_id(division)
    id = (Division.first(:conditions => "code = '#{division}' or name = '#{division}'", :order => "id DESC").id.to_i rescue 0)
    return id
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name","principal_code","principal_name"]
      all.each do |division|
        csv << [division.code, division.name, division.principal.code, division.principal.name]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["code", "name","principal_code","principal_name"]
      all.each do |division|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      division = find_by_code(row["code"]) || new
      principal = Principal.find_by_code(row["principal_code"].upcase)
      unless principal
        principal = Principal.new code: row["principal_code"].upcase, name: row["principal_name"].upcase
        principal.save
      end
      parameters = ActionController::Parameters.new(row.to_hash)
      division.update(name: parameters[:name], code: parameters[:code], principal_id: (principal.id rescue nil))
      division.save!
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
