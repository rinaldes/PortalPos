class DiscountsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :discount, :name
  # GET /discounts
  # GET /discounts.json
  def index
    get_paginated_discounts
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Discount.all.to_csv2 }
      else
        format.csv { send_data Discount.all.to_csv }
      end
    end
  end

  def import
    Discount.import(params[:file])
    redirect_to discounts_path, notice: "Discount imported."
  end

  def show
    @discount = Discount.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @skus = Sku.limit(7).order('name').map(&:name)
    @discount = Discount.new(params[:discount])
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /discounts/1/edit
  def edit
    @skus = Sku.limit(7).order('name').map(&:name)
    @discount = Discount.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # POST /discounts
  # POST /discounts.json
  def create
    init = params[:discount][:name][0]
    discount_number = Discount.create_number(params)
    @discount = Discount.new(discount_params.merge(:code => (('%03d' % ((Discount.last.code.to_i rescue 0)+1)))))
    if @discount.save
      flash[:notice] = 'Divisi berhasil ditambahkan'
      redirect_to discounts_path
    else
      flash[:error] = @discount.errors.full_messages
      render "new"
    end
  end

  # PUT /discounts/1
  # PUT /discounts/1.json
  def update
    @discount = Discount.find(params[:id])
    old1 = @discount.discount_hargas.map(&:id)
    old2 = @discount.discount_products.map(&:id)
    if @discount.update_attributes(discount_params)
      DiscountHarga.where("id IN (#{old1.join(', ')})").delete_all if old1.present?
      DiscountProduct.where("id IN (#{old2.join(', ')})").delete_all if old2.present?
      flash[:notice] = 'Discount was successfully updated.'
      redirect_to discounts_path
    else
      flash[:error] = @discount.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /discounts/1
  # DELETE /discounts/1.json
  def destroy
  @discount = Discount.find(params[:id])
    @discount.destroy
    get_paginated_discounts
    respond_to do |format|
      format.js
    end
  end

  def search
    @discounts = Discount.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @discount = Discount.new
      format.js
    end
  end

  def get_number
    @discount_number = Discount.number(params)
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

  def add_discount_harga
    respond_to do |format|
      format.js
    end
  end

  def add_discount_product
    respond_to do |format|
      format.js
    end
  end

private
  def get_paginated_discounts
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @discounts = Discount.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '))
      .select("discounts.*")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end

  def discount_params
    params.require(:discount).permit(:code, :name, :start, :end, :pilihan, :multi, :flag, :batas, :multi_persen, :multi_nilai, :cakupan, discount_products_attributes: [:sku_id, :min, :max, :percent], discount_hargas_attributes: [:code, :min, :max, :jenis, :percent, :price])
  end
end
