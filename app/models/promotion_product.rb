class PromotionProduct < ActiveRecord::Base
  belongs_to :promotion
  belongs_to :sku
end