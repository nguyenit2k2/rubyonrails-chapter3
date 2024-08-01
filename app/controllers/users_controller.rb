class UsersController < ApplicationController
  include Pagy::Backend
  include Pagy::Frontend
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  after_action :verify_authorized, except: [:index, :show]
  after_action :verify_policy_scoped, only: :index
  
  def index
    @pagy, @users = pagy(policy_scope(User).where(activated: true))
    Rails.logger.debug("Pagy object: #{@pagy.inspect}")
  end
  def show
    @user = User.find(params[:id])
    # @pagy, @microposts = pagy(@user.microposts.page(params[:page]))
    @pagy, @microposts = pagy(@user.microposts.order(created_at: :desc).page(params[:page]))
    authorize @user
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end
  
  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end
  def destroy
    User.find(params[:id]).destroy
    authorize @user
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    authorize @user
    @pagy, @users = pagy(@user.following.paginate(page: params[:page]))
    render 'show_follow', status: :unprocessable_entity
 end

 def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    authorize @user
    @pagy, @users = pagy(@user.followers.paginate(page: params[:page]))
    render 'show_follow', status: :unprocessable_entity
 end
    private

      def user_params
        params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
      end
      # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url, status: :see_other
      end
    end
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end
end