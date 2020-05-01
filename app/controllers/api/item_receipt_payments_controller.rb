class Api::ItemReceiptPaymentsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    item_receipt_payment = []
    if params[:itemReceiptPaymentDetails].present?
      first_detail = ActiveSupport::JSON.decode(params[:itemReceiptPaymentDetails]).first
  #    ItemReceiptPayment.delete_all
      ItemReceiptPayment.api(params[:itemReceiptPaymentDetails])
    end
    render json: {status: 'success'}, status: 200
  end

  def index
    get_paginated_item_receipt_payments
    respond_to do |format|
      format.html
      format.js
      if(params[:a] == "a")
        format.csv { send_data ItemReceiptPayment.all.to_csv2 }
      else
        format.csv { send_data ItemReceiptPayment.all.to_csv }
      end
    end
  end

private
  def get_paginated_item_receipt_payments
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @item_receipt_payments = ItemReceiptPayment.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '))
      .select("item_receipt_payments.*")
      .paginate(:page => params[:page], :per_page => 10) || []
  end
end