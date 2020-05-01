class SubbeatsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :subbeat, :name
  # GET /subbeats
  # GET /subbeats.json
  def index
    get_paginated_subbeats
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Subbeat.all.to_csv2 }
      else
        format.csv { send_data Subbeat.all.to_csv }
      end
    end
  end

  def import
    Subbeat.import(params[:file])
    redirect_to subbeats_path, notice: "Subbeat imported."
  end

  def show
    @subbeat = Subbeat.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @subbeat = Subbeat.new(params[:subbeat])
    @beats = Beat.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /subbeats/1/edit
  def edit
    @subbeat = Subbeat.find(params[:id])
    @beats = Beat.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /subbeats
  # POST /subbeats.json
  def create
    init = params[:subbeat][:name][0]
    beat = Beat.find_by_name(params[:beat_id])
    subbeat_number = Subbeat.create_number(params)
    @subbeat = Subbeat.new(subbeat_params.merge(:beat_id => (beat.id rescue nil)))
    if @subbeat.save
      flash[:notice] = t(:successfully_created)
      redirect_to subbeats_path
    else
      flash[:error] = @subbeat.errors.full_messages.join('<br/>')
      render "new"
    end
  end

  # PUT /subbeats/1
  # PUT /subbeats/1.json
  def update
    @subbeat = Subbeat.find(params[:id])
    if @subbeat.update_attributes(subbeat_params)
      flash[:notice] = 'Subbeat was successfully updated.'
      redirect_to subbeats_path
    else
      flash[:error] = @subbeat.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /subbeats/1
  # DELETE /subbeats/1.json
  def destroy
  @subbeat = Subbeat.find(params[:id])
    @subbeat.destroy
    get_paginated_subbeats
    respond_to do |format|
      format.js
    end
  end

  def search
    @subbeats = Subbeat.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @subbeat = Subbeat.new
      format.js
    end
  end

  def get_number
    @subbeat_number = Subbeat.number(params)
    respond_to do |format|
      format.js
    end
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
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

  def subbeat_params
    params.require(:subbeat).permit(:code, :name, :beat_id)
  end
end
