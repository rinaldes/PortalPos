class Product < ActiveRecord::Base
  belongs_to :brand
  belongs_to :colour
  belongs_to :colour2, class_name: 'Colour'
  belongs_to :colour3, class_name: 'Colour'
  belongs_to :colour4, class_name: 'Colour'
  belongs_to :m_class
  belongs_to :unit
  belongs_to :size

  has_many :product_details
  has_many :branch_prices

  accepts_nested_attributes_for :product_details, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :branch_prices, reject_if: :all_blank, allow_destroy: true

  mount_uploader :image, ImageUploader
end