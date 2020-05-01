class SkusController < ApplicationController
skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :sku, :name
  # GET /skus
  # GET /skus.json
  def index
    get_paginated_skus
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Sku.all.to_csv2 }
      else
        format.csv { send_data Sku.all.to_csv }
      end
    end
  end

  def import
    Sku.import(params[:file])
    redirect_to skus_path, notice: "Sku imported."
  end

  def show
    @sku = Sku.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @sku = Sku.new(params[:sku])
    @brands = Brand.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /skus/1/edit
  def edit
    @sku = Sku.find(params[:id])
    @brands = Brand.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /skus
  # POST /skus.json
  def create
    init = params[:sku][:name][0]
    brand_id = Brand.find_by_name(params[:brand_id])
    sku_number = Sku.create_number(params)
    @sku = Sku.new(sku_params.merge(:code => (('%03d' % ((Sku.last.code.to_i rescue 0)+1)))).merge(:brand_id => brand_id.id))
    if @sku.save
      flash[:notice] = 'Divisi berhasil ditambahkan'
      redirect_to skus_path
    else
      flash[:error] = @sku.errors.full_messages
      render "new"
    end
  end

  # PUT /skus/1
  # PUT /skus/1.json
  def update
    @sku = Sku.find(params[:id])
    if @sku.update_attributes(sku_params)
      flash[:notice] = 'Sku was successfully updated.'
      redirect_to skus_path
    else
      flash[:error] = @sku.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /skus/1
  # DELETE /skus/1.json
  def destroy
  @sku = Sku.find(params[:id])
    @sku.destroy
    get_paginated_skus
    respond_to do |format|
      format.js
    end
  end

  def search
    @skus = Sku.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @sku = Sku.new
      format.js
    end
  end

  def get_number
    @sku_number = Sku.number(params)
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
  def get_paginated_skus
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @skus = Sku.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(brand: {category: :division})
      .select("skus.*, brands.code AS brand_code, brands.name AS brand_name, categories.code AS category_code, categories.name AS category_name, divisions.code AS division_code, divisions.name AS division_name")
      .paginate(:page => params[:page], :per_page => 10) || []
  end

  def sku_params
    params.require(:sku).permit(:code, :name, :brand_id)
  end
end