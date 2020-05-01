class KelurahansController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :kelurahan, :name
  # GET /kelurahans
  # GET /kelurahans.json
  def index
    get_paginated_kelurahans
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Kelurahan.all.to_csv2 }
      else
        format.csv { send_data Kelurahan.all.to_csv }
      end
    end
  end

  def import
    Kelurahan.import(params[:file])
    redirect_to kelurahans_path, notice: "Kelurahan imported."
  end

  def show
    @kelurahan = Kelurahan.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @kelurahan = Kelurahan.new(params[:kelurahan])
    @kecamatans = Kecamatan.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /kelurahans/1/edit
  def edit
    @kelurahan = Kelurahan.find(params[:id])
    @kecamatans = Kecamatan.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /kelurahans
  # POST /kelurahans.json
  def create
    kecamatan = Kecamatan.find_by_name(params[:kecamatan_id])
    @kelurahan = Kelurahan.new(kelurahan_params.merge(kecamatan_id: (kecamatan.id rescue nil)))
    if @kelurahan.save
      flash[:notice] = 'Divisi berhasil ditambahkan'
      redirect_to kelurahans_path
    else
      flash[:error] = @kelurahan.errors.full_messages.join('<br/>')
      render "new"
    end
  end

  # PUT /kelurahans/1
  # PUT /kelurahans/1.json
  def update
    @kelurahan = Kelurahan.find(params[:id])
    if @kelurahan.update_attributes(kelurahan_params)
      flash[:notice] = 'Kelurahan was successfully updated.'
      redirect_to kelurahans_path
    else
      flash[:error] = @kelurahan.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /kelurahans/1
  # DELETE /kelurahans/1.json
  def destroy
  @kelurahan = Kelurahan.find(params[:id])
    @kelurahan.destroy
    get_paginated_kelurahans
    respond_to do |format|
      format.js
    end
  end

  def search
    @kelurahans = Kelurahan.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @kelurahan = Kelurahan.new
      format.js
    end
  end

  def get_number
    @kelurahan_number = Kelurahan.number(params)
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
  def get_paginated_kelurahans
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @kelurahans = Kelurahan.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(kecamatan: {city: {province: :wilayah}})
      .select("kelurahans.*, kecamatans.code AS kecamatan_code, kecamatans.name AS kecamatan_name, cities.code AS city_code, cities.name AS city_name, provinces.code AS province_code, provinces.name AS province_name, wilayahs.code AS wilayah_code, wilayahs.name AS wilayah_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end

  def kelurahan_params
    params.require(:kelurahan).permit(:code, :name, :kecamatan_id)
  end
end
