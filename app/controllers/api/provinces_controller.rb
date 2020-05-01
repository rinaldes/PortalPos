class Api::ProvincesController < ApplicationController
  autocomplete :province, :name
  # GET /provinces
  # GET /provinces.json
  def index
    get_paginated_provinces
    if @provinces.to_json 
      History.create(:name => 'Province', :status => 'Completed')
      render json: @provinces.to_json
    else
      History.create(:name => 'Province', :status => 'Failed')
    end
  end

private
  def get_paginated_provinces
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @provinces = Province.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(:wilayah)
      .select("provinces.*, wilayahs.code AS wilayah_code, wilayahs.name AS wilayah_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end
end
