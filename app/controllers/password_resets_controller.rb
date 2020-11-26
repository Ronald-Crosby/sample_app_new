class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_password_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render "new"
    end
  end
  
  def edit
  end
  
  # If the password update is successful do this
  def update
    if @user.password_reset_expired?
      flash[:danger] = "Password reset link has expired"
      redirect_to new_password_reset_url
    elsif params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update(user_params)
      reset_session
      log_in @user
      flash[:success] = "Your password has been updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
  
end
