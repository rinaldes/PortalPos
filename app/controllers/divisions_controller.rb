class DivisionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :division, :name
  # GET /divisions
  # GET /divisions.json
  def index
    get_paginated_divisions
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Division.all.to_csv2 }
      else
        format.csv { send_data Division.all.to_csv }
      end
    end
  end

  def import
    Division.import(params[:file])
    redirect_to divisions_path, notice: "Division imported."
  end

  def show
    @division = Division.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @division = Division.new(params[:division])
    @principals = Principal.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /divisions/1/edit
  def edit
    @division = Division.find(params[:id])
    @principals = Principal.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /divisions
  # POST /divisions.json
  def create
    principal = Principal.find_by_name(params[:principal_id])
    @division = Division.new(division_params.merge(principal_id: (principal.id rescue nil)))
    if @division.save
      flash[:notice] = 'Divisi berhasil ditambahkan'
      redirect_to divisions_path
    else
      flash[:error] = @division.errors.full_messages.join('<br/>')
      render "new"
    end
  end

  # PUT /divisions/1
  # PUT /divisions/1.json
  def update
    @division = Division.find(params[:id])
    if @division.update_attributes(division_params)
      flash[:notice] = 'Division was successfully updated.'
      redirect_to divisions_path
    else
      flash[:error] = @division.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /divisions/1
  # DELETE /divisions/1.json
  def destroy
  @division = Division.find(params[:id])
    @division.destroy
    get_paginated_divisions
    respond_to do |format|
      format.js
    end
  end

  def search
    @divisions = Division.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @division = Division.new
      format.js
    end
  end

  def get_number
    @division_number = Division.number(params)
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
  def get_paginated_divisions
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @divisions = Division.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(:principal)
      .select("divisions.*, principals.code AS principal_code, principals.name AS principal_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end

  def division_params
    params.require(:division).permit(:code, :name, :principal_id)
  end
end
