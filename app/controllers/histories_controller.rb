class HistoriesController < ApplicationController

  def index
    get_paginated_histories
    respond_to do |format|
      format.html
      format.js
    end
  end

  def search
    @histories = History.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @history = History.new
      format.js
    end
  end

private
  def get_paginated_histories
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @histories = History.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '), 'created_at DESC').paginate(:page => params[:page], :per_page => 10) || []
  end
end
