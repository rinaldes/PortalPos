class Api::ReturToSuppliersController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def create
    retur_to_supplier = []
    first_detail = ActiveSupport::JSON.decode(params[:returToSuppliers]).first
#    ReturToSupplier.delete_all
    ReturToSupplier.api(params[:returToSuppliers])
    render json: {status: 'success'}, status: 200
  end

  def index
    get_paginated_retur_to_suppliers
    respond_to do |format|
      format.html
      format.js
      if(params[:a] == "a")
        format.csv { send_data ReturToSupplier.all.to_csv2 }
      else
        format.csv { send_data ReturToSupplier.all.to_csv }
      end
    end
  end

private
  def get_paginated_retur_to_suppliers
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @retur_to_suppliers = ReturToSupplier.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '))
      .select("retur_to_suppliers.*")
      .paginate(:page => params[:page], :per_page => 10) || []
  end
end