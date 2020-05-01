class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :set_locale

#  def authenticate_user!
 #   return User.first
  #end

  def authenticate_admin
    unless current_user.role == "admin"
      redirect_to root_path, :notice => "Authenticated admin needed here!"
    end
  end

  def set_locale
    session[:language] = 'en' unless session[:language]
    I18n.locale = session[:language]
    Rails.application.routes.default_url_options[:locale]= I18n.locale
  end

  def admin_authentication
    unless current_admin
      redirect_to admin_root_path, :notice => "Authenticated admin needed here!"
    end
  end

  def admin_authenticate
    if current_admin
      redirect_to admin_dashboard_path, :notice => "Already logged in as #{current_admin.email}!"
    end
  end

  private
  def current_admin
    @current_admin ||= Admin.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
    # @current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id]
  end

end
