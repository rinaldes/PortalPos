class Api::SubbeatsController < ApplicationController
  autocomplete :subbeat, :name
  # GET /subbeats
  # GET /subbeats.json
  def index
    get_paginated_subbeats
    if @subbeats.to_json 
      History.create(:name => 'Subbeat', :status => 'Completed')
      render json: @subbeats.to_json
    else
      History.create(:name => 'Subbeat', :status => 'Failed')
    end
  end

private
  def get_paginated_subbeats
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @subbeats = Subbeat.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(beat: {distrik: :distributor})
      .select("subbeats.*, beats.code AS beat_code, beats.name AS beat_name, distriks.code AS distrik_code, distriks.name AS distrik_name, distributors.code AS distributor_code, distributors.name AS distributor_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end
end
