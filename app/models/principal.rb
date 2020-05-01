class Principal < ActiveRecord::Base
  JOIN = ''
  ORDER = 'principals.id'
  SELECTED = 'principals.*'
  GROUP_BY = 'principals.id'

  before_save :upcase_save
  has_many :divisions

  validates :name, presence: true, length: {minimum: 3, maximum: 50}, uniqueness: true
  validates :code, presence: true, length: {minimum: 3, maximum: 50}, uniqueness: true

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
    number = (Principal.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:principal][:name][0]
    number = (Principal.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_principal_id(principal)
    id = (Principal.first(:conditions => "code = '#{principal}' or name = '#{principal}'", :order => "id DESC").id.to_i rescue 0)
    return id
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w(code name address no_telp1 no_telp2 fax email)
      all.each do |principal|
        csv << [principal.code, principal.name, principal.address, principal.no_telp1, principal.no_telp2, principal.fax, principal.email]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << %w(code name address no_telp1 no_telp2 fax email)
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      principal = find_by_code(row["code"]) || new
      parameters = ActionController::Parameters.new(row.to_hash)
      principal.update(parameters.permit(:code, :name, :address, :no_telp1, :no_telp2, :fax, :email))
      principal.save!
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
