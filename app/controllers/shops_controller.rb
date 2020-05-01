class ShopsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :shop, :name
  # GET /shops
  # GET /shops.json
  def index
    get_paginated_shops
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Shop.all.to_csv2 }
      else
        format.csv { send_data Shop.all.to_csv }
      end
    end
  end

  def import
    Shop.import(params[:file])
    redirect_to shops_path, notice: "Shop imported."
  end

  def show
    @shop = Shop.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @shop = Shop.new(params[:shop])
    @subbeats = Subbeat.limit(7).order('name').map(&:name)
    @kelurahans = Kelurahan.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /shops/1/edit
  def edit
    @shop = Shop.find(params[:id])
    @subbeats = Subbeat.limit(7).order('name').map(&:name)
    @kelurahans = Kelurahan.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /shops
  # POST /shops.json
  def create
    subbeat = Subbeat.find_by_name(params[:subbeat_id])
    kelurahan = Kelurahan.find_by_name(params[:kelurahan_id])
    @shop = Shop.new(shop_params.merge(subbeat_id: (subbeat.id rescue nil), kelurahan_id: (kelurahan.id rescue nil)))
    if @shop.save
      flash[:notice] = t(:successfully_updated)
      redirect_to shops_path
    else
      flash[:error] = @shop.errors.full_messages.join('<br/>')
      render "new"
    end
  end

  # PUT /shops/1
  # PUT /shops/1.json
  def update
    @shop = Shop.find(params[:id])
    if @shop.update_attributes(shop_params)
      flash[:notice] = 'Shop was successfully updated.'
      redirect_to shops_path
    else
      flash[:error] = @shop.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.json
  def destroy
  @shop = Shop.find(params[:id])
    @shop.destroy
    get_paginated_shops
    respond_to do |format|
      format.js
    end
  end

  def search
    @shops = Shop.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @shop = Shop.new
      format.js
    end
  end

  def get_number
    @shop_number = Shop.number(params)
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
  def get_paginated_shops
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @shops = Shop.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(subbeat: {beat: {distrik: {distributor: {area: :region}}}} ).joins(kelurahan: {kecamatan: :city})
      .select("shops.*, cities.code AS city_code, cities.name AS city_name, distributors.code AS distributor_code, areas.name AS area_name, regions.name AS region_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end

  def shop_params
    params.require(:shop).permit(:code, :name, :address, :telp, :fax, :email, :npwp, :subbeat_id, :kelurahan_id)
  end
end
