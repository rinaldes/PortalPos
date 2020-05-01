class KecamatansController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :kecamatan, :name
  # GET /kecamatans
  # GET /kecamatans.json
  def index
    get_paginated_kecamatans
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Kecamatan.all.to_csv2 }
      else
        format.csv { send_data Kecamatan.all.to_csv }
      end
    end
  end

  def import
    Kecamatan.import(params[:file])
    redirect_to kecamatans_path, notice: "Kecamatan imported."
  end

  def show
    @kecamatan = Kecamatan.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @kecamatan = Kecamatan.new(params[:kecamatan])
    @cities = City.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /kecamatans/1/edit
  def edit
    @kecamatan = Kecamatan.find(params[:id])
    @cities = City.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /kecamatans
  # POST /kecamatans.json
  def create
    city = City.find_by_name(params[:city_id])
    @kecamatan = Kecamatan.new(kecamatan_params.merge(city_id: (city.id rescue nil)))
    if @kecamatan.save
      flash[:notice] = t(:successfully_created)
      redirect_to kecamatans_path
    else
      flash[:error] = @kecamatan.errors.full_messages.join('<br/>')
      render "new"
    end
  end

  # PUT /kecamatans/1
  # PUT /kecamatans/1.json
  def update
    @kecamatan = Kecamatan.find(params[:id])
    if @kecamatan.update_attributes(kecamatan_params)
      flash[:notice] = 'Kecamatan was successfully updated.'
      redirect_to kecamatans_path
    else
      flash[:error] = @kecamatan.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /kecamatans/1
  # DELETE /kecamatans/1.json
  def destroy
  @kecamatan = Kecamatan.find(params[:id])
    @kecamatan.destroy
    get_paginated_kecamatans
    respond_to do |format|
      format.js
    end
  end

  def search
    @kecamatans = Kecamatan.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @kecamatan = Kecamatan.new
      format.js
    end
  end

  def get_number
    @kecamatan_number = Kecamatan.number(params)
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
  def get_paginated_kecamatans
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @kecamatans = Kecamatan.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(city: {province: :wilayah})
      .select("kecamatans.*, cities.code AS city_code, cities.name AS city_name, provinces.code AS province_code, provinces.name AS province_name, wilayahs.code AS wilayah_code, wilayahs.name AS wilayah_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end

  def kecamatan_params
    params.require(:kecamatan).permit(:code, :name, :city_id)
  end
end
