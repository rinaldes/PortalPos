class AppsUpdater < ActiveRecord::Base
  JOIN = ''
  ORDER = 'apps_updaters.id'
  SELECTED = 'apps_updaters.*'
  GROUP_BY = 'apps_updaters.id'

  before_save :upcase_save

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
    number = (AppsUpdater.first(:conditions => "name like '#{params[:first_char]}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.create_number(params)
    init = params[:apps_updater][:name][0]
    number = (AppsUpdater.first(:conditions => "name like '#{init}%'", :order => "id DESC").code[1..-1].to_i rescue 0)+1
    return number
  end

  def self.get_apps_updater_id(apps_updater)
    id = (AppsUpdater.first(:conditions => "code = '#{apps_updater}' or name = '#{apps_updater}'", :order => "id DESC").id.to_i rescue 0)
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
end