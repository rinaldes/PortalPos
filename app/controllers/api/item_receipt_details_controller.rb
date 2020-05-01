class Api::ItemReceiptDetailsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    item_receipt_detail = []
    first_detail = ActiveSupport::JSON.decode(params[:item_receipt_details]).first
    ItemReceiptDetail.delete_all
    ItemReceiptDetail.api(params[:item_receipt_details])
    render json: {status: 'success'}, status: 200
  end
end