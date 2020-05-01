class ProductPricesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :product_price, :name
  # GET /product_prices
  # GET /product_prices.json
  def index
    get_paginated_product_prices
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data ProductPrice.all.to_csv2 }
      else
        format.csv { send_data ProductPrice.all.to_csv }
      end
    end
  end

  def import
    ProductPrice.import(params[:file])
    redirect_to product_prices_path, notice: "Product Price imported."
  end

  def show
    @product_price = ProductPrice.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @product_price = ProductPrice.new(params[:product_price])
    #@price_groups = PriceGroup.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /product_prices/1/edit
  def edit
    @product_price = ProductPrice.find(params[:id])
    #@price_groups = PriceGroup.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /product_prices
  # POST /product_prices.json
  def create
    init = params[:product_price][:name][0]
    #price_group_id = PriceGroup.find_by_name(params[:price_group_id])
    product_price_number = ProductPrice.create_number(params)
    @product_price = ProductPrice.new(product_price_params.merge(:code => (('%03d' % ((ProductPrice.last.code.to_i rescue 0)+1)))))
    if @product_price.save
      flash[:notice] = 'Harga Produk berhasil ditambahkan'
      redirect_to product_prices_path
    else
      flash[:error] = @product_price.errors.full_messages
      render "new"
    end
  end

  # PUT /product_prices/1
  # PUT /product_prices/1.json
  def update
    @product_price = ProductPrice.find(params[:id])
    if @product_price.update_attributes(product_price_params)
      flash[:notice] = 'Product Price was successfully updated.'
      redirect_to product_prices_path
    else
      flash[:error] = @product_price.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /product_prices/1
  # DELETE /product_prices/1.json
  def destroy
  @product_price = ProductPrice.find(params[:id])
    @product_price.destroy
    get_paginated_product_prices
    respond_to do |format|
      format.js
    end
  end

  def search
    @product_prices = ProductPrice.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @product_price = ProductPrice.new
      format.js
    end
  end

  def get_number
    @product_price_number = ProductPrice.number(params)
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
  def get_paginated_product_prices
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @product_prices = ProductPrice.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '))
      .select("product_prices.*")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end

  def product_price_params
    params.require(:product_price).permit(:code, :name, :h_jual_kecil, :h_jual_menengah, :h_jual_besar)
  end
end
