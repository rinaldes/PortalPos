class SalesOrdersController < ApplicationController

  def show
    @sales_order = SalesOrder.find params[:id]
    @sales_orders_d = SaleOrderDetail.where(:sales_order_id => params[:id])
  end

  def index
    get_paginated_sales_orders
    respond_to do |format|
      format.html
      format.js
      if(params[:a] == "a")
        format.csv { send_data SalesOrder.all.to_csv2 }
      else
        format.csv { send_data SalesOrder.all.to_csv }
      end
    end
  end

private
  def get_paginated_sales_orders
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @sales_orders = SalesOrder.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '))
      .select("sales_orders.*")
      .paginate(:page => params[:page], :per_page => 10) || []
  end
end
