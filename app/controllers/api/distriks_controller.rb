class Api::DistriksController < ApplicationController
  autocomplete :distrik, :name
  # GET /distriks
  # GET /distriks.json
  def index
    get_paginated_distriks
    if @distriks.to_json 
      History.create(:name => 'Distrik', :status => 'Completed')
      render json: @distriks.to_json
    else
      History.create(:name => 'Distrik', :status => 'Failed')
    end
  end

private
  def get_paginated_distriks
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @distriks = Distrik.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(:distributor)
      .select("distriks.*, distributors.code AS distributor_code, distributors.name AS distributor_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end
end
