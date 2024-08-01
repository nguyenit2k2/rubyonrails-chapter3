class ApplicationController < ActionController::Base
    include SessionsHelper
    include Pundit
    include Pagy::Backend
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
  end