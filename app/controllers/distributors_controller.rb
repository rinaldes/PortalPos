class DistributorsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :distributor, :name
  # GET /distributors
  # GET /distributors.json
  def index
    get_paginated_distributors
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Distributor.all.to_csv2 }
      else
        format.csv { send_data Distributor.all.to_csv }
      end
    end
  end

  def import
    Distributor.import(params[:file])
    redirect_to distributors_path, notice: "Distributor imported."
  end

  def show
    @distributor = Distributor.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @distributor = Distributor.new(params[:distributor])
    @areas = Area.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /distributors/1/edit
  def edit
    @distributor = Distributor.find(params[:id])
    @areas = Area.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /distributors
  # POST /distributors.json
  def create
    init = params[:distributor][:name][0]
    area_id = Area.find_by_name(params[:area_id])
    distributor_number = Distributor.create_number(params)
    @distributor = Distributor.new(distributor_params.merge(:area_id => (area_id.id rescue nil)))
    if @distributor.save
      flash[:notice] = t(:successfully_created)
      redirect_to distributors_path
    else
      flash[:error] = @distributor.errors.full_messages.join('<br/>')
      render "new"
    end
  end

  # PUT /distributors/1
  # PUT /distributors/1.json
  def update
    @distributor = Distributor.find(params[:id])
    if @distributor.update_attributes(distributor_params)
      flash[:notice] = 'Distributor was successfully updated.'
      redirect_to distributors_path
    else
      flash[:error] = @distributor.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /distributors/1
  # DELETE /distributors/1.json
  def destroy
  @distributor = Distributor.find(params[:id])
    @distributor.destroy
    get_paginated_distributors
    respond_to do |format|
      format.js
    end
  end

  def search
    @distributors = Distributor.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @distributor = Distributor.new
      format.js
    end
  end

  def get_number
    @distributor_number = Distributor.number(params)
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
  def get_paginated_distributors
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @distributors = Distributor.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(area: :region)
      .select("distributors.*, areas.code AS area_code, areas.name AS area_name, regions.code AS region_code, regions.name AS region_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end

  def distributor_params
    params.require(:distributor).permit(:code, :name, :address, :telp1, :telp2, :email, :fax, :area_id)
  end
end