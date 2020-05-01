class RegionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :region, :name
  # GET /regions
  # GET /regions.json
  def index
    get_paginated_regions
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Region.all.to_csv2 }
      else
        format.csv { send_data Region.all.to_csv }
      end
    end
  end

  def import
    Region.import(params[:file])
    redirect_to regions_path, notice: "Region imported."
  end

  def show
    @region = Region.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @region = Region.new(params[:region])
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /regions/1/edit
  def edit
    @region = Region.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # POST /regions
  # POST /regions.json
  def create
    init = params[:region][:name][0]
    region_number = Region.create_number(params)
    @region = Region.new(region_params)
    if @region.save
      flash[:notice] = 'Warna berhasil ditambahkan'
      redirect_to regions_path
    else
      flash[:error] = @region.errors.full_messages.join('<br/>')
      render "new"
    end
  end

  # PUT /regions/1
  # PUT /regions/1.json
  def update
    @region = Region.find(params[:id])
    if @region.update_attributes(region_params)
      flash[:notice] = 'Region was successfully updated.'
      redirect_to regions_path
    else
      flash[:error] = @region.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /regions/1
  # DELETE /regions/1.json
  def destroy
  @region = Region.find(params[:id])
    @region.destroy
    get_paginated_regions
    respond_to do |format|
      format.js
    end
  end

  def search
    @regions = Region.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @region = Region.new
      format.js
    end
  end

  def get_number
    @region_number = Region.number(params)
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
  def get_paginated_regions
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @regions = Region.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).paginate(:page => params[:page], :per_page => 10) || []
  end

  def region_params
    params.require(:region).permit(:code, :name)
  end
end
