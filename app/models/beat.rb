class Beat < ActiveRecord::Base
	JOIN = ''
  ORDER = 'beats.id'
  SELECTED = 'beats.*'
  GROUP_BY = 'beats.id'

  before_save :upcase_save
  has_many :subbeats
  belongs_to :distrik

  validates :name, presence: true, :length => {minimum: 3, maximum: 50}, uniqueness: true
  validates :code, presence: true, :length => {minimum: 3, maximum: 50}, uniqueness: true
  validates :distrik_id, presence: true

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
    number = (Beat.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:beat][:name][0]
    number = (Beat.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_beat_id(beat)
    id = (Beat.first(:conditions => "code = '#{beat}' or name = '#{beat}'", :order => "id DESC").id.to_i rescue 0)
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
      csv << ["code", "name", "distributor_code", "distributor_name", "distrik_code", "distrik_name"]
      all.each do |beat|
        csv << [beat.code, beat.name, beat.distrik.distributor.code, beat.distrik.distributor.name, beat.distrik.code, beat.distrik.name]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["name", "distrik_name"]
      all.each do |beat|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      beat = find_by_id(row["id"]) || new
      distrik = Distrik.find_by_name(row["distrik_name"].upcase)
      parameters = ActionController::Parameters.new(row.to_hash)
      beat.update(parameters.permit(:name).merge(:code => (('%03d' % ((Colour.last.code.to_i rescue 0)+1)))).merge(:distrik_id => distrik.id))
      beat.save!
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
