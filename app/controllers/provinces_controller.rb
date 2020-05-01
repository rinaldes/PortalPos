class ProvincesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :province, :name
  # GET /provinces
  # GET /provinces.json
  def index
    get_paginated_provinces
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Province.all.to_csv2 }
      else
        format.csv { send_data Province.all.to_csv }
      end
    end
  end

  def import
    Province.import(params[:file])
    redirect_to provinces_path, notice: "Province imported."
  end

  def show
    @province = Province.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @province = Province.new(params[:province])
    @wilayahs = Wilayah.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /provinces/1/edit
  def edit
    @province = Province.find(params[:id])
    @wilayahs = Wilayah.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /provinces
  # POST /provinces.json
  def create
    wilayah = Wilayah.find_by_name(params[:wilayah_id])
    @province = Province.new(province_params.merge(wilayah: (wilayah.id rescue nil)))
    if @province.save
      flash[:notice] = t(:successfully_created)
      redirect_to provinces_path
    else
      flash[:error] = @province.errors.full_messages.join('<br/>')
      render "new"
    end
  end

  # PUT /provinces/1
  # PUT /provinces/1.json
  def update
    @province = Province.find(params[:id])
    if @province.update_attributes(province_params)
      flash[:notice] = 'Province was successfully updated.'
      redirect_to provinces_path
    else
      flash[:error] = @province.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /provinces/1
  # DELETE /provinces/1.json
  def destroy
  @province = Province.find(params[:id])
    @province.destroy
    get_paginated_provinces
    respond_to do |format|
      format.js
    end
  end

  def search
    @provinces = Province.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @province = Province.new
      format.js
    end
  end

  def get_number
    @province_number = Province.number(params)
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
  def get_paginated_provinces
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @provinces = Province.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(:wilayah)
      .select("provinces.*, wilayahs.code AS wilayah_code, wilayahs.name AS wilayah_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end

  def province_params
    params.require(:province).permit(:code, :name, :wilayah_id)
  end
end
