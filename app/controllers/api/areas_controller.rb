class Api::AreasController < ApplicationController
  autocomplete :area, :name
  # GET /areas
  # GET /areas.json
  def index
    get_paginated_areas
    if @areas.to_json 
      History.create(:name => 'Daerah', :status => 'Completed')
      render json: @areas.to_json
    else
      History.create(:name => 'Daerah', :status => 'Failed')
    end
  end

private
  def get_paginated_areas
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @areas = Area.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(:region)
      .select("areas.*, regions.code AS region_code, regions.name AS region_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end
end
