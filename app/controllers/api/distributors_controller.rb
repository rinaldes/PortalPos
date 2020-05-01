class Api::DistributorsController < ApplicationController
  autocomplete :distributor, :name
  # GET /distributors
  # GET /distributors.json
  def index
    get_paginated_distributors
    if @distributors.to_json 
      History.create(:name => 'Penyalur', :status => 'Completed')
      render json: @distributors.to_json
    else
      History.create(:name => 'Penyalur', :status => 'Failed')
    end
  end

private
  def get_paginated_distributors
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @distributors = Distributor.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(area: :region)
      .select("distributors.*, areas.code AS area_code, areas.name AS area_name, regions.code AS region_code, regions.name AS region_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end
end