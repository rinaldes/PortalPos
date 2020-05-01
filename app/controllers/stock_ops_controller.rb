class StockOpsController < ApplicationController

  def index
    get_paginated_stock_ops
    respond_to do |format|
      format.html
      format.js
      if(params[:a] == "a")
        format.csv { send_data StockOp.all.to_csv2 }
      else
        format.csv { send_data StockOp.all.to_csv }
      end
    end
  end

private
  def get_paginated_stock_ops
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @stock_ops = StockOp.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '))
      .select("stock_ops.*")
      .paginate(:page => params[:page], :per_page => 10) || []
  end
end