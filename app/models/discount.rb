class Discount < ActiveRecord::Base
  JOIN = ''
  ORDER = 'discounts.id'
  SELECTED = 'discounts.*'
  GROUP_BY = 'discounts.id'

  before_save :upcase_save

  validates :name, :presence => {:message => 'harus diisi'}, :length => {:minimum => 3, :maximum => 50, :message => 'minimal 3 karakter'}, :uniqueness => {:message => 'sudah dipakai'}
  has_many :discount_hargas
  has_many :discount_products
  accepts_nested_attributes_for :discount_hargas, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :discount_products, :reject_if => :all_blank, :allow_destroy => true
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
    number = (Discount.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:discount][:name][0]
    number = (Discount.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_discount_id(discount)
    id = (Discount.first(:conditions => "code = '#{discount}' or name = '#{discount}'", :order => "id DESC").id.to_i rescue 0)
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
      csv << ["code", "name", "start", "end", "pilihan", "multi", "flag", "batas", "multi_persen", "multi_nilai", "cakupan"]
      all.each do |discount|
        csv << [discount.code, discount.name, discount.start, discount.end, discount.pilihan, discount.multi, discount.flag, discount.batas, discount.multi_persen, discount.multi_nilai, discount.cakupan]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["name", "start", "end", "pilihan", "multi", "flag", "batas", "multi_persen", "multi_nilai", "cakupan"]
      all.each do |discount|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      discount = find_by_id(row["id"]) || new
      parameters = ActionController::Parameters.new(row.to_hash)
      discount.update(parameters.permit(:name, :start, :end, :pilihan, :multi, :flag, :batas, :multi_persen, :multi_nilai, :cakupan).merge(:code => (('%03d' % ((Discount.last.code.to_i rescue 0)+1)))))
      discount.save!
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
