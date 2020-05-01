class Api::KelurahansController < ApplicationController
  autocomplete :kelurahan, :name
  # GET /kelurahans
  # GET /kelurahans.json
  def index
    get_paginated_kelurahans
    if @kelurahans.to_json 
      History.create(:name => 'Kelurahan', :status => 'Completed')
      render json: @kelurahans.to_json
    else
      History.create(:name => 'Kelurahan', :status => 'Failed')
    end
  end

private
  def get_paginated_kelurahans
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @kelurahans = Kelurahan.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(kecamatan: {city: {province: :wilayah}})
      .select("kelurahans.*, kecamatans.code AS kecamatan_code, kecamatans.name AS kecamatan_name, cities.code AS city_code, cities.name AS city_name, provinces.code AS province_code, provinces.name AS province_name, wilayahs.code AS wilayah_code, wilayahs.name AS wilayah_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end
end
