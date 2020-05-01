class StockOpDetail < ActiveRecord::Base
    belongs_to :stock_op, foreign_key: 'stok_op_id'
end