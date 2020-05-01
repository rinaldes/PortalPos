class Api::RegionsController < ApplicationController
  autocomplete :region, :name
  # GET /regions
  # GET /regions.json
  def index
    get_paginated_regions
    if @regions.to_json 
      History.create(:name => 'Wilayah Sales Area', :status => 'Completed')
      render json: @regions.to_json
    else
      History.create(:name => 'Wilayah Sales Area', :status => 'Failed')
    end
  end

private
  def get_paginated_regions
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @regions = Region.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).paginate(:page => params[:page], :per_page => 10) || []
  end
end
