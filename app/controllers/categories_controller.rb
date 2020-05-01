class CategoriesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:destroy]
  autocomplete :category, :name
  # GET /categories
  # GET /categories.json
  def index
    get_paginated_categories
    respond_to do |format|
      format.html
      format.js
      format.xls
      if(params[:a] == "a")
        format.csv { send_data Category.all.to_csv2 }
      else
        format.csv { send_data Category.all.to_csv }
      end
    end
  end

  def import
    Category.import(params[:file])
    redirect_to categories_path, notice: "Category imported."
  end

  def show
    @category = Category.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @category = Category.new(params[:category])
    @divisions = Division.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    @divisions = Division.limit(7).order('name').map(&:name)
    respond_to do |format|
      format.html
    end
  end

  # POST /categories
  # POST /categories.json
  def create
    init = params[:category][:name][0]
    division = Division.find_by_name(params[:division_id].upcase)
    category_number = Category.create_number(params)
    @category = Category.new(category_params.merge(:code => (('%03d' % ((Category.last.code.to_i rescue 0)+1)))).merge(:division_id => division.id))
    if @category.save
      flash[:notice] = 'Category was successfully added'
      redirect_to categories_path
    else
      flash[:error] = @category.errors.full_messages
      render "new"
    end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      flash[:notice] = 'Category was successfully updated.'
      redirect_to categories_path
    else
      flash[:error] = @category.errors.full_messages
      # format.js
      render "edit"
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
  @category = Category.find(params[:id])
    @category.destroy
    get_paginated_categories
    respond_to do |format|
      format.js
    end
  end

  def search
    @categories = Category.search(params[:search]).uniq.paginate(:page => params[:page], :per_page => 10) || []
    respond_to do |format|
      @category = Category.new
      format.js
    end
  end

  def get_number
    @category_number = Category.number(params)
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
  def get_paginated_categories
    conditions = []
    params[:search].each{|param|
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'"
    } if params[:search].present?
    @categories = Category.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(:division)
      .select("categories.*, divisions.code AS division_code, divisions.name AS division_name")
    	.paginate(:page => params[:page], :per_page => 10) || []
  end

  def category_params
    params.require(:category).permit(:code, :name, :division_id)
  end
end