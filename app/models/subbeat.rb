class Subbeat < ActiveRecord::Base
	JOIN = ''
  ORDER = 'subbeats.id'
  SELECTED = 'subbeats.*'
  GROUP_BY = 'subbeats.id'

  before_save :upcase_save
  belongs_to :beat
  has_many :shops

  validates :name, presence: true, :length => {minimum: 3, maximum: 50}, uniqueness: true
  validates :code, presence: true, :length => {minimum: 3, maximum: 50}, uniqueness: true
  validates :beat_id, presence: true

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
    number = (Subbeat.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:subbeat][:name][0]
    number = (Subbeat.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_subbeat_id(subbeat)
    id = (Subbeat.first(:conditions => "code = '#{subbeat}' or name = '#{subbeat}'", :order => "id DESC").id.to_i rescue 0)
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
      csv << ["code", "name", "beat_code", "beat_name", "distrik_code", "distrik_name", "distributor_code", "distributor_name"]
      all.each do |subbeat|
        csv << [subbeat.code, subbeat.name, subbeat.beat.code, subbeat.beat.name, subbeat.beat.distrik.code, subbeat.beat.distrik.name, subbeat.beat.distrik.distributor.code, subbeat.beat.distrik.distributor.name]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["name", "subbeat_name"]
      all.each do |subbeat|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      subbeat = find_by_id(row["id"]) || new
      beat = Beat.find_by_name(row["beat_name"].upcase)
      parameters = ActionController::Parameters.new(row.to_hash)
      subbeat.update(parameters.permit(:name).merge(:code => (('%03d' % ((Subbeat.last.code.to_i rescue 0)+1)))).merge(:beat_id => beat.id))
      subbeat.save!
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
