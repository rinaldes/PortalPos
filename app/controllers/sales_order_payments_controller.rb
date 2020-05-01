class SalesOrderPaymentsController < ApplicationController

  def index
    get_paginated_sales_order_payments
    respond_to do |format|
      format.html
      format.js
      if(params[:a] == "a")
        format.csv { send_data SalesOrderPayment.all.to_csv2 }
      else
        format.csv { send_data SalesOrderPayment.all.to_csv }
      end
    end
  end

private
  def get_paginated_sales_order_payments
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @sales_order_payments = SalesOrderPayment.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '))
      .select("sales_order_payments.*")
      .paginate(:page => params[:page], :per_page => 10) || []
  end
end