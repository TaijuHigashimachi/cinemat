class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :set_user, only: %i[show edit update watched]
  before_action :set_movie_statuses, only: %i[show watched]

  def show
    # movie_statusesのデータから、ステータスがwatchのものだけ取得
    movie_status_watches = @movie_statuses.where(status: 'watch')

    # ステータスがwatchのデータのmovie_idを配列に保存
    movie_id_array = []
    movie_status_watches.size.times do |i|
      movie_id_array.push(movie_status_watches[i]['movie_id'])
    end

    # movie_idの配列でwhere検索
    @watch_movies = Movie.where(id: movie_id_array)
  end

  def watched
    movie_status_watched = @movie_statuses.where(status: 'watched')

    movie_id_array = []
    movie_status_watched.size.times do |i|
      movie_id_array.push(movie_status_watched[i]['movie_id'])
    end

    @watched_movies = Movie.where(id: movie_id_array)
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
    if @user.update!(user_params)
      redirect_to user_path(@user), success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :show
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
end
