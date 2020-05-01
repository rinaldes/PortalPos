class LicensesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :license, :code
  # GET /licenses
  # GET /licenses.json
  def index
    get_paginated_licenses
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data License.all.to_csv2 }
      else
        format.csv { send_data License.all.to_csv }
      end
    end
  end

  def import
    License.import(params[:file])
    redirect_to licenses_path, notice: "License imported."
  end

  def show
    @license = License.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @license = License.new(params[:license])
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /licenses/1/edit
  def edit
    @license = License.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # POST /licenses
  # POST /licenses.json
  def create
    1.upto(params[:jumlah].to_i) {|a|
        License.create(license_params.merge(:code => SecureRandom.hex(21)))
      }
      redirect_to licenses_path
  end

  # PUT /licenses/1
  # PUT /licenses/1.json
  def update
    @license = License.find(params[:id])
    if @license.update_attributes(license_params)
      flash[:notice] = 'License was successfully updated.'
      redirect_to licenses_path
    else
      flash[:error] = @license.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /licenses/1
  # DELETE /licenses/1.json
  def destroy
  @license = License.find(params[:id])
    @license.destroy
    get_paginated_licenses
    respond_to do |format|
      format.js
    end
  end

  def search
    @licenses = License.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @license = License.new
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
  def get_paginated_licenses
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @licenses = License.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).paginate(:page => params[:page], :per_page => 10) || []
  end

  def license_params
    params.require(:license).permit(:code, :name, :jumlah)
  end
end
