class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  before_action :require_login

  private

  def not_authenticated
    flash[:warning] = t('defaults.message.require_login')
    redirect_to login_url
  end

  def admin_only
    if current_user.role != 'admin'
      flash[:warning] = t('defaults.message.not_authorized')
      redirect_to login_url
    end
  end
end
