class Api::KecamatansController < ApplicationController
  autocomplete :kecamatan, :name
  # GET /kecamatans
  # GET /kecamatans.json
  def index
    get_paginated_kecamatans
    if @kecamatans.to_json 
      History.create(:name => 'Kecamatan', :status => 'Completed')
      render json: @kecamatans.to_json
    else
      History.create(:name => 'Kecamatan', :status => 'Failed')
    end
  end

private
  def get_paginated_kecamatans
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @kecamatans = Kecamatan.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(city: {province: :wilayah})
      .select("kecamatans.*, cities.code AS city_code, cities.name AS city_name, provinces.code AS province_code, provinces.name AS province_name, wilayahs.code AS wilayah_code, wilayahs.name AS wilayah_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end
end
