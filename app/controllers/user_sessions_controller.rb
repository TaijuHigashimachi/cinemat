class UserSessionsController < ApplicationController
  before_action :require_login, only: %i[destroy]

  def new
    @user = User.new
  end

  def create
    @user = login(params[:user][:email], params[:user][:password])
    if @user
      redirect_back_or_to root_path
    else
      @user = User.new(email: params[:user][:email])
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, success: t('.success')
  end
end
