class PrincipalsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :principal, :name
  # GET /principals
  # GET /principals.json
  def index
    get_paginated_principals
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Principal.all.to_csv2 }
      else
        format.csv { send_data Principal.all.to_csv }
      end
    end
  end

  def import
    Principal.import(params[:file])
    redirect_to principals_path, notice: "Principal imported."
  end

  def show
    @principal = Principal.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @principal = Principal.new(params[:principal])
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /principals/1/edit
  def edit
    @principal = Principal.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # POST /principals
  # POST /principals.json
  def create
    @principal = Principal.new(principal_params)
    if @principal.save
      flash[:notice] = 'Warna berhasil ditambahkan'
      redirect_to principals_path
    else
      flash[:error] = @principal.errors.full_messages.join('<br/>')
      render "new"
    end
  end

  # PUT /principals/1
  # PUT /principals/1.json
  def update
    @principal = Principal.find(params[:id])
    if @principal.update_attributes(principal_params)
      flash[:notice] = 'Principal was successfully updated.'
      redirect_to principals_path
    else
      flash[:error] = @principal.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /principals/1
  # DELETE /principals/1.json
  def destroy
  @principal = Principal.find(params[:id])
    @principal.destroy
    get_paginated_principals
    respond_to do |format|
      format.js
    end
  end

  def search
    @principals = Principal.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @principal = Principal.new
      format.js
    end
  end

  def get_number
    @principal_number = Principal.number(params)
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
  def get_paginated_principals
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @principals = Principal.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).paginate(:page => params[:page], :per_page => 10) || []
  end

  def principal_params
    params.require(:principal).permit(:code, :name, :address, :no_telp1, :no_telp2, :fax, :email)
  end
end
