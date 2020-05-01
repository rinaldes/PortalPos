class Api::PengirimanBarangController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    sales_order = []
    first_detail = ActiveSupport::JSON.decode(params[:sales_orders]).first
    SalesOrder.api2(params[:sales_orders])

    render json: {status: 'success'}, status: 200
  end
end