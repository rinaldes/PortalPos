class SaleOrderDetail < ActiveRecord::Base
  belongs_to :sales_order, foreign_key: 'sales_order_id'
end