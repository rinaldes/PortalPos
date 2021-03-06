class Api::ReturOrdersController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    retur_order = []
    first_detail = ActiveSupport::JSON.decode(params[:returOrders]).first
#    ReturOrder.delete_all
    ReturOrder.api(params[:returOrders])
    render json: {status: 'success'}, status: 200
  end

  def index
    get_paginated_retur_orders
    respond_to do |format|
      format.html
      format.js
      if(params[:a] == "a")
        format.csv { send_data ReturOrder.all.to_csv2 }
      else
        format.csv { send_data ReturOrder.all.to_csv }
      end
    end
  end

private
  def get_paginated_retur_orders
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @retur_orders = ReturOrder.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '))
      .select("retur_orders.*")
      .paginate(:page => params[:page], :per_page => 10) || []
  end
end