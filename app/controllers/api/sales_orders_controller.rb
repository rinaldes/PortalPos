class Api::SalesOrdersController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    sales_order = []
    first_detail = ActiveSupport::JSON.decode(params[:salesOrders]).first
#    SalesOrder.delete_all
    SalesOrder.api(params[:salesOrders])
    render json: {status: 'success'}, status: 200
  end

  def update
    sales_order = []
    first_detail = ActiveSupport::JSON.decode(params[:sales_orders]).first
#    SalesOrder.delete_all
    SalesOrder.api2(params[:sales_orders])
    render json: {status: 'success'}, status: 200
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