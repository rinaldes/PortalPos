class TypeUlinon < ActiveRecord::Base
	JOIN = ''
  ORDER = 'type_ulinons.id'
  SELECTED = 'type_ulinons.*'
  GROUP_BY = 'type_ulinons.id'

  before_save :upcase_save

  validates :name, presence: true, :length => {minimum: 3, maximum: 50}, uniqueness: true

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
    number = (TypeUlinon.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:type_ulinon][:name][0]
    number = (TypeUlinon.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_type_ulinon_id(type_ulinon)
    id = (TypeUlinon.first(:conditions => "code = '#{type_ulinon}' or name = '#{type_ulinon}'", :order => "id DESC").id.to_i rescue 0)
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
      csv << ["code", "name"]
      all.each do |type_ulinon|
        csv << [type_ulinon.code, type_ulinon.name]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["name"]
      all.each do |type_ulinon|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      type_ulinon = find_by_id(row["id"]) || new
      parameters = ActionController::Parameters.new(row.to_hash)
      type_ulinon.update(parameters.permit(:name).merge(:code => (('%03d' % ((TypeUlinon.last.code.to_i rescue 0)+1)))))
      type_ulinon.save!
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