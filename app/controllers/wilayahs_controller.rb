class WilayahsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :wilayah, :name
  # GET /wilayahs
  # GET /wilayahs.json
  def index
    get_paginated_wilayahs
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Wilayah.all.to_csv2 }
      else
        format.csv { send_data Wilayah.all.to_csv }
      end
    end
  end

  def import
    Wilayah.import(params[:file])
    redirect_to wilayahs_path, notice: "Wilayah imported."
  end

  def show
    @wilayah = Wilayah.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @wilayah = Wilayah.new(params[:wilayah])
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /wilayahs/1/edit
  def edit
    @wilayah = Wilayah.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # POST /wilayahs
  # POST /wilayahs.json
  def create
    init = params[:wilayah][:name][0]
    wilayah_number = Wilayah.create_number(params)
    @wilayah = Wilayah.new(wilayah_params.merge(:code => (('%03d' % ((Wilayah.last.code.to_i rescue 0)+1)))))
    if @wilayah.save
      flash[:notice] = 'Divisi berhasil ditambahkan'
      redirect_to wilayahs_path
    else
      flash[:error] = @wilayah.errors.full_messages
      render "new"
    end
  end

  # PUT /wilayahs/1
  # PUT /wilayahs/1.json
  def update
    @wilayah = Wilayah.find(params[:id])
    if @wilayah.update_attributes(wilayah_params)
      flash[:notice] = 'Wilayah was successfully updated.'
      redirect_to wilayahs_path
    else
      flash[:error] = @wilayah.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /wilayahs/1
  # DELETE /wilayahs/1.json
  def destroy
  @wilayah = Wilayah.find(params[:id])
    @wilayah.destroy
    get_paginated_wilayahs
    respond_to do |format|
      format.js
    end
  end

  def search
    @wilayahs = Wilayah.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @wilayah = Wilayah.new
      format.js
    end
  end

  def get_number
    @wilayah_number = Wilayah.number(params)
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
  def get_paginated_wilayahs
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @wilayahs = Wilayah.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '))
      .select("wilayahs.*")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end

  def wilayah_params
    params.require(:wilayah).permit(:code, :name)
  end
end
