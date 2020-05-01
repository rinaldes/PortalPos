class Api::PlusController < ApplicationController
  # GET /plus
  # GET /plus.json
  def index
    get_paginated_plus
    if @plus.to_json 
      History.create(:name => 'PLU', :status => 'Completed')
      render json: @plus.to_json
    else
      History.create(:name => 'PLU', :status => 'Failed')
    end
  end

private
  def get_paginated_plus
    conditions = []
    params[:search].each{|param|
    begin
      conditions << "LOWER(#{param[0]}) LIKE '%#{param[1]}%'" 
    rescue 
      conditions << "(#{param[0]}) LIKE '%#{param[1]}%'"
    end
    } if params[:search].present?
    @plus = Plu.where(conditions.join(' AND ')).order(params[:sort].to_s.gsub('-', ' ')).joins(sku: {brand: {category: :division}})
      .select("plus.*, skus.code AS sku_code, skus.name AS sku_name, brands.name AS brand_name, categories.name AS category_name, divisions.name AS division_name")
      .paginate(:page => params[:page], :per_page => 10) || []
  end
end