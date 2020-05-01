class Api::SalesOrderPaymentsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    sales_order_payment = []
    if params[:salesOrderPaymentDetails].present?
      first_detail = ActiveSupport::JSON.decode(params[:salesOrderPaymentDetails]).first
  #    SalesOrderPayment.delete_all
      SalesOrderPayment.api(params[:salesOrderPaymentDetails])
    end
    render json: {status: 'success'}, status: 200
  end

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