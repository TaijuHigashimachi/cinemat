class PasswordResetsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:user][:email])
    @user&.deliver_reset_password_instructions! if @user
    redirect_to root_path, success: t('password_resets.create.success')
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    return not_authenticated if @user.blank?

    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password(params[:user][:password])
      redirect_to root_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :edit
    end
  end
end
