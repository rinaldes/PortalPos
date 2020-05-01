class Api::SaleTransactionDetailsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    sale_transaction_detail = []
    first_detail = ActiveSupport::JSON.decode(params[:sale_transaction_details]).first
    SaleTransactionDetail.delete_all
    SaleTransactionDetail.api(params[:sale_transaction_details])
    render json: {status: 'success'}, status: 200
  end
end