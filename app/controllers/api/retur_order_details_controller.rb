class Api::ReturOrderDetailsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    retur_order_detail = []
    first_detail = ActiveSupport::JSON.decode(params[:retur_order_details]).first
    ReturOrderDetail.delete_all
    ReturOrderDetail.api(params[:retur_order_details])
    render json: {status: 'success'}, status: 200
  end
end