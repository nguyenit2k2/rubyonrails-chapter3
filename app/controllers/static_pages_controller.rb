class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  def home
     if logged_in?
      @micropost  = current_user.microposts.build
      @pagy, @feed_items = pagy(current_user.feed.paginate(page: params[:page]))
     end
     Rails.logger.debug("a1s: #{logged_in?}, #{user_signed_in?} ")
  end

  def help
  end

  def about
  end

  def contact
  end
end