class Admin::BaseController < ApplicationController
  layout 'admin/layouts/application'

  before_action :admin_only

  private

  def admin_only
    return if current_user&.role == 'admin'

    flash[:warning] = t('defaults.message.not_authorized')
    redirect_to login_url
  end
end
