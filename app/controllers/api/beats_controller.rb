class Api::BeatsController < ApplicationController
  autocomplete :beat, :name
  # GET /beats
  # GET /beats.json
  def index
    get_paginated_beats
    if @beats.to_json 
      History.create(:name => 'Beat', :status => 'Completed')
      render json: @beats.to_json
    else
      History.create(:name => 'Beat', :status => 'Failed')
    end
  end

private
  def get_paginated_beats
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @beats = Beat.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(distrik: :distributor)
      .select("beats.*, distriks.code AS distrik_code, distriks.name AS distrik_name, distributors.code AS distributor_code, distributors.name AS distributor_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end
end
