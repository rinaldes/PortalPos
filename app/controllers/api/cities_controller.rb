class Api::CitiesController < ApplicationController
  autocomplete :city, :name
  # GET /cities
  # GET /cities.json
  def index
    get_paginated_cities
    if @cities.to_json 
      History.create(:name => 'Kota', :status => 'Completed')
      render json: @cities.to_json
    else
      History.create(:name => 'Kota', :status => 'Failed')
    end
  end

  
private
  def get_paginated_cities
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @cities = City.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(province: :wilayah)
      .select("cities.*, provinces.code AS province_code, provinces.name AS province_name, wilayahs.code AS wilayah_code, wilayahs.name AS wilayah_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end
end
