class SaleTransactionsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def show
    @sale_transaction = SaleTransaction.find(params[:id])
  end

  def create
    sale_transaction = []
    first_detail = ActiveSupport::JSON.decode(params[:saleTransactions]).first
#    SaleTransaction.delete_all
    SaleTransaction.api(params[:saleTransactions])
    render json: {status: 'success'}, status: 200
  end

  def index
    get_paginated_sale_transactions
    respond_to do |format|
      format.html
      format.js
      if(params[:a] == "a")
        format.csv { send_data SaleTransaction.all.to_csv2 }
      else
        format.csv { send_data SaleTransaction.all.to_csv }
      end
    end
  end

private
  def get_paginated_sale_transactions
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @sale_transactions = SaleTransaction.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '))
      .select("sale_transactions.*")
      .paginate(:page => params[:page], :per_page => 10) || []
  end
end
