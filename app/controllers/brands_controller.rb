class BrandsController < ApplicationController
skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :brand, :name
  # GET /brands
  # GET /brands.json
  def index
    get_paginated_brands
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Brand.all.to_csv2 }
      else
        format.csv { send_data Brand.all.to_csv }
      end
    end
  end

  def import
    Brand.import(params[:file])
    redirect_to brands_path, notice: "Brand imported."
  end

  def show
    @brand = Brand.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @brand = Brand.new(params[:brand])
    @categories = Category.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /brands/1/edit
  def edit
    @brand = Brand.find(params[:id])
    @categories = Category.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /brands
  # POST /brands.json
  def create
    init = params[:brand][:name][0]
    category_id = Category.find_by_name(params[:category_id])
    brand_number = Brand.create_number(params)
    @brand = Brand.new(brand_params.merge(:code => (('%03d' % ((Brand.last.code.to_i rescue 0)+1)))).merge(:category_id => category_id.id))
    if @brand.save
      flash[:notice] = 'Divisi berhasil ditambahkan'
      redirect_to brands_path
    else
      flash[:error] = @brand.errors.full_messages
      render "new"
    end
  end

  # PUT /brands/1
  # PUT /brands/1.json
  def update
    @brand = Brand.find(params[:id])
    if @brand.update_attributes(brand_params)
      flash[:notice] = 'Brand was successfully updated.'
      redirect_to brands_path
    else
      flash[:error] = @brand.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.json
  def destroy
  @brand = Brand.find(params[:id])
    @brand.destroy
    get_paginated_brands
    respond_to do |format|
      format.js
    end
  end

  def search
    @brands = Brand.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @brand = Brand.new
      format.js
    end
  end

  def get_number
    @brand_number = Brand.number(params)
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
  def get_paginated_brands
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @brands = Brand.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(category: :division)
      .select("brands.*, categories.code AS category_code, categories.name AS category_name, divisions.code AS division_code, divisions.name AS division_name")
      .paginate(:page => params[:page], :per_page => 10) || []
  end

  def brand_params
    params.require(:brand).permit(:code, :name, :category_id)
  end
end