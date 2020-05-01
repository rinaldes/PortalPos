class PromotionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :promotion, :name
  # GET /promotions
  # GET /promotions.json
  def index
    get_paginated_promotions
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Promotion.all.to_csv2 }
      else
        format.csv { send_data Promotion.all.to_csv }
      end
    end
  end

  def import
    Promotion.import(params[:file])
    redirect_to promotions_path, notice: "Promotion imported."
  end

  def show
    @promotion = Promotion.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @promotion = Promotion.new(params[:promotion])
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /promotions/1/edit
  def edit
    @promotion = Promotion.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # POST /promotions
  # POST /promotions.json
  def create
    init = params[:promotion][:name][0]
    promotion_number = Promotion.create_number(params)
    @promotion = Promotion.new(promotion_params.merge(:code => (('%03d' % ((Promotion.last.code.to_i rescue 0)+1)))))
    if @promotion.save
      flash[:notice] = 'Warna berhasil ditambahkan'
      redirect_to promotions_path
    else
      flash[:error] = @promotion.errors.full_messages
      render "new"
    end
  end

  # PUT /promotions/1
  # PUT /promotions/1.json
  def update
    @promotion = Promotion.find(params[:id])
    if @promotion.update_attributes(promotion_params)
      flash[:notice] = 'Promotion was successfully updated.'
      redirect_to promotions_path
    else
      flash[:error] = @promotion.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /promotions/1
  # DELETE /promotions/1.json
  def destroy
  @promotion = Promotion.find(params[:id])
    @promotion.destroy
    get_paginated_promotions
    respond_to do |format|
      format.js
    end
  end

  def search
    @promotions = Promotion.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @promotion = Promotion.new
      format.js
    end
  end

  def get_number
    @promotion_number = Promotion.number(params)
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

  def add_promotion_product
    respond_to do |format|
      format.js
    end
  end

private
  def get_paginated_promotions
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @promotions = Promotion.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).paginate(:page => params[:page], :per_page => 10) || []
  end

  def promotion_params
    params.require(:promotion).permit(:code, :name, :start, :end, :flag_range, :max_apply, :min_bruto, :bruto_value, :multipler_purchase_limit, :multipler_getpercent, :multipler_getprice, :multipler_getquantity, :min_price, :all_outtype, :all_outgroup, :all_salesman, :all_outlet, :all_team, :flag_multiple, :coverage_id, promotion_products_attributes: [:sku_id])
  end
end
