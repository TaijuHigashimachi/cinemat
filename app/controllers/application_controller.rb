class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  before_action :require_login

  private

  def not_authenticated
    flash[:warning] = 'ログインが必要です'
    redirect_to login_url
  end
end
