class TypeUlinonsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :type_ulinon, :name
  # GET /type_ulinons
  # GET /type_ulinons.json
  def index
    get_paginated_type_ulinons
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data TypeUlinon.all.to_csv2 }
      else
        format.csv { send_data TypeUlinon.all.to_csv }
      end
    end
  end

  def import
    TypeUlinon.import(params[:file])
    redirect_to type_ulinons_path, notice: "TypeUlinon imported."
  end

  def show
    @type_ulinon = TypeUlinon.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @type_ulinon = TypeUlinon.new(params[:type_ulinon])
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /type_ulinons/1/edit
  def edit
    @type_ulinon = TypeUlinon.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # POST /type_ulinons
  # POST /type_ulinons.json
  def create
    init = params[:type_ulinon][:name][0]
    type_ulinon_number = TypeUlinon.create_number(params)
    @type_ulinon = TypeUlinon.new(type_ulinon_params.merge(:code => (('%03d' % ((TypeUlinon.last.code.to_i rescue 0)+1)))))
    if @type_ulinon.save
      flash[:notice] = 'Divisi berhasil ditambahkan'
      redirect_to type_ulinons_path
    else
      flash[:error] = @type_ulinon.errors.full_messages
      render "new"
    end
  end

  # PUT /type_ulinons/1
  # PUT /type_ulinons/1.json
  def update
    @type_ulinon = TypeUlinon.find(params[:id])
    if @type_ulinon.update_attributes(type_ulinon_params)
      flash[:notice] = 'TypeUlinon was successfully updated.'
      redirect_to type_ulinons_path
    else
      flash[:error] = @type_ulinon.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /type_ulinons/1
  # DELETE /type_ulinons/1.json
  def destroy
  @type_ulinon = TypeUlinon.find(params[:id])
    @type_ulinon.destroy
    get_paginated_type_ulinons
    respond_to do |format|
      format.js
    end
  end

  def search
    @type_ulinons = TypeUlinon.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @type_ulinon = TypeUlinon.new
      format.js
    end
  end

  def get_number
    @type_ulinon_number = TypeUlinon.number(params)
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
  def get_paginated_type_ulinons
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @type_ulinons = TypeUlinon.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '))
      .select("type_ulinons.*")
      .paginate(:page => params[:page], :per_page => 10) || []
  end

  def type_ulinon_params
    params.require(:type_ulinon).permit(:code, :name)
  end
end