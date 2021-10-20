class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :set_user, only: %i[show edit update]

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_url, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  def update
    if @user.update!(user_params)
      redirect_to user_path(@user), success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :show
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :role, :password, :password_confirmation)
  end
end
