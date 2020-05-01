class Api::ReturToSupplierDetailsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    retur_to_supplier_detail = []
    first_detail = ActiveSupport::JSON.decode(params[:retur_to_supplier_details]).first
    ReturToSupplierDetail.delete_all
    ReturToSupplierDetail.api(params[:retur_to_supplier_details])
    render json: {status: 'success'}, status: 200
  end
end