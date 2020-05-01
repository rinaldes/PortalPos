class CashOutController < ApplicationController
  def index
    get_paginated_cash_outs
    respond_to do |format|
      format.html
      format.js
      if(params[:a] == "a")
        format.csv { send_data CashInCashOut.all.to_csv2 }
      else
        format.csv { send_data CashInCashOut.all.to_csv }
      end
    end
  end

private
  def get_paginated_cash_outs
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @cash_outs = CashInCashOut.where(conditions.join(' AND ')).where(:tipe => 2).order(params[:sort].to_s.gsub('-', ' '))
      .select("cash_in_cash_outs.*")
      .paginate(:page => params[:page], :per_page => 10) || []
  end

  def cash_out_params
    params.require(:cash_out).permit(:code, :name, :region_id)
  end
end