class AreasController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :area, :name
  # GET /areas
  # GET /areas.json
  def index
    get_paginated_areas
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Area.all.to_csv2 }
      else
        format.csv { send_data Area.all.to_csv }
      end
    end
  end

  def import
    Area.import(params[:file])
    redirect_to areas_path, notice: "Area imported."
  end

  def show
    @area = Area.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @area = Area.new(params[:area])
    @regions = Region.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /areas/1/edit
  def edit
    @area = Area.find(params[:id])
    @regions = Region.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /areas
  # POST /areas.json
  def create
    init = params[:area][:name][0]
    region_id = Region.find_by_name(params[:region_id])
    area_number = Area.create_number(params)
    @area = Area.new(area_params.merge(:region_id => (region_id.id rescue nil)))
    if @area.save
      flash[:notice] = t(:successfully_created)
      redirect_to areas_path
    else
      flash[:error] = @area.errors.full_messages.join('<br/>')
      render "new"
    end
  end

  # PUT /areas/1
  # PUT /areas/1.json
  def update
    @area = Area.find(params[:id])
    if @area.update_attributes(area_params)
      flash[:notice] = 'Area was successfully updated.'
      redirect_to areas_path
    else
      flash[:error] = @area.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /areas/1
  # DELETE /areas/1.json
  def destroy
  @area = Area.find(params[:id])
    @area.destroy
    get_paginated_areas
    respond_to do |format|
      format.js
    end
  end

  def search
    @areas = Area.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @area = Area.new
      format.js
    end
  end

  def get_number
    @area_number = Area.number(params)
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
  def get_paginated_areas
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @areas = Area.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(:region)
      .select("areas.*, regions.code AS region_code, regions.name AS region_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end

  def area_params
    params.require(:area).permit(:code, :name, :region_id)
  end
end
