class BeatsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :beat, :name

  def index
    get_paginated_beats
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Beat.all.to_csv2 }
      else
        format.csv { send_data Beat.all.to_csv }
      end
    end
  end

  def import
    Beat.import(params[:file])
    redirect_to beats_path, notice: "Beat imported."
  end

  def show
    @beat = Beat.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @beat = Beat.new(params[:beat])
    @distriks = Distrik.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @beat = Beat.find(params[:id])
    @distriks = Distrik.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  def create
    init = params[:beat][:name][0]
    distrik = Distrik.find_by_name(params[:distrik_id])
    beat_number = Beat.create_number(params)
    @beat = Beat.new(beat_params.merge(:distrik_id => (distrik.id rescue nil
    )))
    if @beat.save
      flash[:notice] = 'Divisi berhasil ditambahkan'
      redirect_to beats_path
    else
      flash[:error] = @beat.errors.full_messages.join('<br/>')
      render "new"
    end
  end

  def update
    @beat = Beat.find(params[:id])
    if @beat.update_attributes(beat_params)
      flash[:notice] = 'Beat was successfully updated.'
      redirect_to beats_path
    else
      flash[:error] = @beat.errors.full_messages
      # format.js
      render "edit"
    end
  end

  def destroy
  @beat = Beat.find(params[:id])
    @beat.destroy
    get_paginated_beats
    respond_to do |format|
      format.js
    end
  end

  def search
    @beats = Beat.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @beat = Beat.new
      format.js
    end
  end

  def get_number
    @beat_number = Beat.number(params)
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
  def get_paginated_beats
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @beats = Beat.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(distrik: :distributor)
      .select("beats.*, distriks.code AS distrik_code, distriks.name AS distrik_name, distributors.code AS distributor_code, distributors.name AS distributor_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end

  def beat_params
    params.require(:beat).permit(:code, :name, :distrik_id)
  end
end
