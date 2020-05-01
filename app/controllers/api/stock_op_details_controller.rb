class Api::StockOpDetailsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    stock_op_detail = []
    first_detail = ActiveSupport::JSON.decode(params[:stock_op_details]).first
    StockOpDetail.delete_all
    StockOpDetail.api(params[:stock_op_details])
    render json: {status: 'success'}, status: 200
  end
end