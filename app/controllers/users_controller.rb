class UsersController < ApplicationController
  include Pagy::Backend

  before_action :require_login, only: %i[show watched uninterested edit update]
  before_action :set_user, only: %i[show edit update watched uninterested]
  before_action :set_movie_statuses, only: %i[show watched uninterested]

  def show
    @pagy, @watch_movies = pagy_array(movie_search_by_status(@movie_statuses, 'watch').order(updated_at: :asc), items: 2)
  end

  def watched
    @pagy, @watched_movies = pagy_array(movie_search_by_status(@movie_statuses, 'watched').order(updated_at: :asc), items: 2)
  end

  def uninterested
    @pagy, @uninterested_movies = pagy_array(movie_search_by_status(@movie_statuses, 'uninterested').order(updated_at: :asc), items: 2)
  end

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
    if @user.update(user_params)
      redirect_to user_path(@user), success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :role, :password, :password_confirmation)
  end

  def set_movie_statuses
    # current_userが登録しているmovie_statusesのデータを取得
    @movie_statuses = current_user.movie_statuses
  end

  def movie_search_by_status(movie_statuses, status)
    # movie_statusesのデータから、ステータスがstatusのものだけ取得し、movie_idを配列に保存
    movie_id_array = movie_statuses.where(status: status).map { |i| i['movie_id'] }

    # movie_idの配列でwhere検索
    Movie.where(id: movie_id_array)
  end
end
