class PlusController < ApplicationController
skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :plu, :name
  # GET /plus
  # GET /plus.json
  def index
    get_paginated_plus
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Plu.all.to_csv2 }
      else
        format.csv { send_data Plu.all.to_csv }
      end
    end
  end

  def import
    Plu.import(params[:file])
    redirect_to plus_path, notice: "Plu imported."
  end

  def show
    @plu = Plu.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @plu = Plu.new(params[:plu])
    @skus = Sku.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /plus/1/edit
  def edit
    @plu = Plu.find(params[:id])
    @skus = Sku.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /plus
  # POST /plus.json
  def create
    sku_id = Sku.find_by_name(params[:sku_id])
    #plu_number = Plu.create_number(params)
    @plu = Plu.new(plu_params.merge(:code => (('%03d' % ((Plu.last.code.to_i rescue 0)+1)))).merge(:sku_id => sku_id.id))
    #init = params[:plu][:code][0]
    if @plu.save
      flash[:notice] = 'Divisi berhasil ditambahkan'
      redirect_to plus_path
    else
      flash[:error] = @plu.errors.full_messages
      render "new"
    end
  end

  # PUT /plus/1
  # PUT /plus/1.json
  def update
    @plu = Plu.find(params[:id])
    if @plu.update_attributes(plu_params)
      flash[:notice] = 'Plu was successfully updated.'
      redirect_to plus_path
    else
      flash[:error] = @plu.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /plus/1
  # DELETE /plus/1.json
  def destroy
  @plu = Plu.find(params[:id])
    @plu.destroy
    get_paginated_plus
    respond_to do |format|
      format.js
    end
  end

  def search
    @plus = Plu.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @plu = Plu.new
      format.js
    end
  end

  def get_number
    @plu_number = Plu.number(params)
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
  def get_paginated_plus
    conditions = []
    params[:search].each{|param|
    begin
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'" 
    rescue 
      conditions << "(#{param[0]}) LIKE '%#{param[1]}%'"
    end
    } if params[:search].present?
    @plus = Plu.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(sku: {brand: {category: :division}})
      .select("plus.*, skus.code AS sku_code, skus.name AS sku_name, brands.name AS brand_name, categories.name AS category_name, divisions.name AS division_name")
      .paginate(:page => params[:page], :per_page => 10) || []
  end

  def plu_params
    params.require(:plu).permit(:code, :sku_id, :h_jual, :h_beli, :satuan)
  end
end