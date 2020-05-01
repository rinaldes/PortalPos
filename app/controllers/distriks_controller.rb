class DistriksController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :distrik, :name
  # GET /distriks
  # GET /distriks.json
  def index
    get_paginated_distriks
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Distrik.all.to_csv2 }
      else
        format.csv { send_data Distrik.all.to_csv }
      end
    end
  end

  def import
    Distrik.import(params[:file])
    redirect_to distriks_path, notice: "Distrik imported."
  end

  def show
    @distrik = Distrik.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @distrik = Distrik.new(params[:distrik])
    @distributors = Distributor.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /distriks/1/edit
  def edit
    @distrik = Distrik.find(params[:id])
    @distributors = Distributor.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /distriks
  # POST /distriks.json
  def create
    init = params[:distrik][:name][0]
    distributor = Distributor.find_by_name(params[:distributor_id])
    distrik_number = Distrik.create_number(params)
    @distrik = Distrik.new(distrik_params.merge(:distributor_id => (distributor.id rescue nil)))
    if @distrik.save
      flash[:notice] = t(:successfully_created)
      redirect_to distriks_path
    else
      flash[:error] = @distrik.errors.full_messages.join('<br/>')
      render "new"
    end
  end

  # PUT /distriks/1
  # PUT /distriks/1.json
  def update
    @distrik = Distrik.find(params[:id])
    if @distrik.update_attributes(distrik_params)
      flash[:notice] = 'Distrik was successfully updated.'
      redirect_to distriks_path
    else
      flash[:error] = @distrik.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /distriks/1
  # DELETE /distriks/1.json
  def destroy
  @distrik = Distrik.find(params[:id])
    @distrik.destroy
    get_paginated_distriks
    respond_to do |format|
      format.js
    end
  end

  def search
    @distriks = Distrik.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @distrik = Distrik.new
      format.js
    end
  end

  def get_number
    @distrik_number = Distrik.number(params)
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
  def get_paginated_distriks
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @distriks = Distrik.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(:distributor)
      .select("distriks.*, distributors.code AS distributor_code, distributors.name AS distributor_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end

  def distrik_params
    params.require(:distrik).permit(:code, :name, :distributor_id)
  end
end
