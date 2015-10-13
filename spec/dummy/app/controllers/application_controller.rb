class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_filter :require_login
  # helper_method :current_user
  #
  # private
  #
  # if Rails.env.test?
  #   prepend_before_filter :stub_current_user
  #
  #   def stub_current_user
  #     session[:user_id] = cookies[:stub_user_id] if cookies[:stub_user_id]
  #   end
  # end
  #
  #
  # def require_login
  #   #return true if request.fullpath =~ /auth/ #Allow omniauth to work
  #
  #   #if session[:user_id].present?
  #     current_user
  #   #else
  #   #  redirect_to '/' unless request.fullpath == "/"
  #   #end
  # end
  #
  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end
end
