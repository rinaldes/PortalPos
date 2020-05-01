class Api::SaleOrderDetailsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    sale_order_detail = []
    first_detail = ActiveSupport::JSON.decode(params[:sale_order_details]).first
    SaleOrderDetail.delete_all
    SaleOrderDetail.api(params[:sale_order_details])
    render json: {status: 'success'}, status: 200
  end
end