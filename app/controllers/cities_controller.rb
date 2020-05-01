class CitiesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]

  def autocomplete_city_name
    hash = []
    suppliers = City.where("LOWER(name) LIKE LOWER('%#{params[:term]}%')").limit(25)
    suppliers.collect do |p|
      hash << {"id" => p.id, "label" => p.name, "value" => p.name, "code" => p.code}
    end
    render json: hash
  end

  # GET /cities
  # GET /cities.json
  def index
    get_paginated_cities
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data City.all.to_csv2 }
      else
        format.csv { send_data City.all.to_csv }
      end
    end
  end

  def import
    City.import(params[:file])
    redirect_to cities_path, notice: "City imported."
  end

  def show
    @city = City.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @city = City.new(params[:city])
    @provinces = Province.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /cities/1/edit
  def edit
    @city = City.find(params[:id])
    @provinces = Province.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /cities
  # POST /cities.json
  def create
    province = Province.find_by_name(params[:province_id])
    @city = City.new(city_params.merge(:province_id => (province.id rescue nil)))
    if @city.save
      flash[:notice] = t(:successfully_created)
      redirect_to cities_path
    else
      flash[:error] = @city.errors.full_messages.join('<br/>')
      render "new"
    end
  end

  # PUT /cities/1
  # PUT /cities/1.json
  def update
    @city = City.find(params[:id])
    if @city.update_attributes(city_params)
      flash[:notice] = 'City was successfully updated.'
      redirect_to cities_path
    else
      flash[:error] = @city.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy
  @city = City.find(params[:id])
    @city.destroy
    get_paginated_cities
    respond_to do |format|
      format.js
    end
  end

  def search
    @cities = City.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @city = City.new
      format.js
    end
  end

  def get_number
    @city_number = City.number(params)
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
  def get_paginated_cities
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @cities = City.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(province: :wilayah)
      .select("cities.*, provinces.code AS province_code, provinces.name AS province_name, wilayahs.code AS wilayah_code, wilayahs.name AS wilayah_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end

  def city_params
    params.require(:city).permit(:code, :name, :province_id)
  end
end
