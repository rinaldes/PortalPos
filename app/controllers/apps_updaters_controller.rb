class AppsUpdatersController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :apps_updater, :name
  # GET /apps_updaters
  # GET /apps_updaters.json
  def index
    get_paginated_apps_updaters
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data AppsUpdater.all.to_csv2 }
      else
        format.csv { send_data AppsUpdater.all.to_csv }
      end
    end
  end

  def import
    AppsUpdater.import(params[:file])
    redirect_to apps_updaters_path, notice: "AppsUpdater imported."
  end

  def show
    @apps_updater = AppsUpdater.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @apps_updater = AppsUpdater.new(params[:apps_updater])
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /apps_updaters/1/edit
  def edit
    @apps_updater = AppsUpdater.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # POST /apps_updaters
  # POST /apps_updaters.json
  def create
    init = params[:apps_updater][:name][0]
    apps_updater_number = AppsUpdater.create_number(params)
    @apps_updater = AppsUpdater.new(apps_updater_params)
    if @apps_updater.save
      flash[:notice] = 'Warna berhasil ditambahkan'
      redirect_to apps_updaters_path
    else
      flash[:error] = @apps_updater.errors.full_messages
      render "new"
    end
  end

  # PUT /apps_updaters/1
  # PUT /apps_updaters/1.json
  def update
    @apps_updater = AppsUpdater.find(params[:id])
    if @apps_updater.update_attributes(apps_updater_params)
      flash[:notice] = 'AppsUpdater was successfully updated.'
      redirect_to apps_updaters_path
    else
      flash[:error] = @apps_updater.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /apps_updaters/1
  # DELETE /apps_updaters/1.json
  def destroy
  @apps_updater = AppsUpdater.find(params[:id])
    @apps_updater.destroy
    get_paginated_apps_updaters
    respond_to do |format|
      format.js
    end
  end

  def search
    @apps_updaters = AppsUpdater.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @apps_updater = AppsUpdater.new
      format.js
    end
  end

  def get_number
    @apps_updater_number = AppsUpdater.number(params)
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
  def get_paginated_apps_updaters
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @apps_updaters = AppsUpdater.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' '), 'code DESC').paginate(:page => params[:page], :per_page => 10) || []
  end

  def apps_updater_params
    params.require(:apps_updater).permit(:code, :name, :date)
  end
end
