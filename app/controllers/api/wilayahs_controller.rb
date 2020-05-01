class Api::WilayahsController < ApplicationController
  autocomplete :wilayah, :name
  # GET /wilayahs
  # GET /wilayahs.json
  def index
    get_paginated_wilayahs
    if @wilayahs.to_json 
      History.create(:name => 'Wilayah Geo Area', :status => 'Completed')
      render json: @wilayahs.to_json
    else
      History.create(:name => 'Wilayah Geo Area', :status => 'Failed')
    end
  end

private
  def get_paginated_wilayahs
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @wilayahs = Wilayah.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '))
      .select("wilayahs.*")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end
end
