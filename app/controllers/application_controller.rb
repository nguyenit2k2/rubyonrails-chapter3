class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery unless: -> { params[:controller] =~ /omniauth_callbacks/ }
  include SessionsHelper
  include Pundit
  include Pagy::Backend
  include Devise::Controllers::Helpers
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    private

      # Confirms a logged-in user.
      def logged_in_user
        unless logged_in?
  
          store_location
          flash[:danger] = "Please log in."
          redirect_to login_url, status: :see_other
        end
      end

      def user_not_authorized
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to(request.referer || root_path)
      end
        
      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
        devise_parameter_sanitizer.permit(:account_update, keys: [:name])
      end
  end