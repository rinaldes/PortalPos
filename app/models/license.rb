class License < ActiveRecord::Base
  JOIN = ''
  ORDER = 'licenses.id'
  SELECTED = 'licenses.*'
  GROUP_BY = 'licenses.id'

  before_save :upcase_save
  
  def upcase_save
    self.code = code.upcase rescue nil
  end
end