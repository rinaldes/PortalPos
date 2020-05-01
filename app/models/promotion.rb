class Promotion < ActiveRecord::Base
  JOIN = ''
  ORDER = 'promotions.id'
  SELECTED = 'promotions.*'
  GROUP_BY = 'promotions.id'

  before_save :upcase_save

  validates :name, :presence => {:message => 'harus diisi'}, :length => {:minimum => 3, :maximum => 50, :message => 'minimal 3 karakter'}, :uniqueness => {:message => 'sudah dipakai'}
  has_many :promotion_products
  accepts_nested_attributes_for :promotion_products, :reject_if => :all_blank, :allow_destroy => true
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
    number = (Promotion.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:promotion][:name][0]
    number = (Promotion.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_promotion_id(promotion)
    id = (Promotion.first(:conditions => "code = '#{promotion}' or name = '#{promotion}'", :order => "id DESC").id.to_i rescue 0)
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
      csv << ["code", "name", "start", "end", "flag_range", "max_apply", "min_bruto", "bruto_value", "multipler_purchase_limit", "multipler_getpercent", "multipler_getprice", "multipler_getquantity", "min_price", "all_outtype", "all_outgroup", "all_salesman", "all_outlet", "all_team", "flag_multiple"]
      all.each do |promotion|
        csv << [promotion.code, promotion.name, promotion.start, promotion.end, promotion.flag_range, promotion.max_apply, promotion.min_bruto, promotion.bruto_value, promotion.multipler_purchase_limit, promotion.multipler_getpercent, promotion.multipler_getprice, promotion.multipler_getquantity, promotion.min_price, promotion.all_outtype, promotion.all_outgroup, promotion.all_salesman, promotion.all_outlet, promotion.all_team, promotion.flag_multiple]
      end
    end
  end

  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
      csv << ["name", "start", "end", "flag_range", "max_apply", "min_bruto", "bruto_value", "multipler_purchase_limit", "multipler_getpercent", "multipler_getprice", "multipler_getquantity", "min_price", "all_outtype", "all_outgroup", "all_salesman", "all_outlet", "all_team", "flag_multiple"]
      all.each do |promotion|
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      promotion = find_by_id(row["id"]) || new
      parameters = ActionController::Parameters.new(row.to_hash)
      promotion.update(parameters.permit(:name, :start, :end, :flag_range, :max_apply, :min_bruto, :bruto_value, :multipler_purchase_limit, :multipler_getpercent, :multipler_getprice, :multipler_getquantity, :min_price, :all_outtype, :all_outgroup, :all_salesman, :all_outlet, :all_team, :flag_multiple).merge(:code => (('%03d' % ((Promotion.last.code.to_i rescue 0)+1)))))
      promotion.save!
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