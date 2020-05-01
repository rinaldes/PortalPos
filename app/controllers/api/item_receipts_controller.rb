class Api::ItemReceiptsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    item_receipt = []
    first_detail = ActiveSupport::JSON.decode(params[:itemReceipts]).first
#    ItemReceipt.delete_all
    ItemReceipt.api(params[:itemReceipts])
    render json: {status: 'success'}, status: 200
  end

  def index
    get_paginated_item_receipts
    respond_to do |format|
      format.html
      format.js
      if(params[:a] == "a")
        format.csv { send_data ItemReceipt.all.to_csv2 }
      else
        format.csv { send_data ItemReceipt.all.to_csv }
      end
    end
  end

private
  def get_paginated_item_receipts
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @item_receipts = ItemReceipt.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '))
      .select("item_receipts.*")
      .paginate(:page => params[:page], :per_page => 10) || []
  end
end