class DashboardsController < ApplicationController
  # before_action :get_blast_messages

  def index
    @topten_products = Product.limit(10)
    @topten_distributors = Distributor.limit(10)
  end

  def show
    @dashboard = BlastMessage.find(params[:id])
  end

  def new
    @dashboards = BlastMessage.all
  end

  def company_new
    @dashboards = BlastMessage.all 
  end

  def visi
    @visi = @current_company.vision
  end

  def misi
    @misi = @current_company.mision
  end

  def code_of_conduct
    @code_of_conduct = @current_company.code_of_conduct
  end

  def culture
    @culture = @current_company.culture
  end

    def value_company
      @value_company = @current_company.value
    end

    def knowledge
      @knowledge = @current_company.knowledge
    end
    # def visi_misi
    #   debugger
    #   @visi = @current_company.vision
    #   @misi = @current_company.mision
    # end

    private
      def visi_misi
        @flag = current_user.flag_company

        if params[:flag].present?
          @flag.update(params[:flag] => false)
        end

        if @flag.present?
          if @flag.vision
            redirect_to action: 'visi'
          elsif @flag.mision
            redirect_to action: 'misi'
          elsif @flag.code_of_conduct
            redirect_to action: 'code_of_conduct'
          elsif @flag.value_company
            redirect_to action: 'value_company'
          elsif @flag.culture
            redirect_to action: 'culture'
          else
            current_user.update(:flag_company_dashboard => false)
            redirect_to action: 'index'
          end

        else
          current_user.update(:flag_company_dashboard => false)
          redirect_to action: 'index'
        end
      end
  # private
  # 	def get_blast_messages
  #   	@blast_messages = BlastMessage.all.map{|x| [x.name, x.id]} 
  # 	end
end
