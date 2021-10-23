class MoviesController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    # 全映画をユーザースコア順に並べて取得
    all_movies = Movie.all.order(user_score: :desc)

    # ブラウザを開き直したとき、最後に観た映画の次の映画から表示
    if cookies['cinemat_movie_id']
      # ブラウザを閉じる前、最後に観ていた映画を取得
      last_viewed_movie = Movie.find(cookies['cinemat_movie_id'].to_i)
      # 全映画の中から、last_viewed_movieの次から最後までのデータを取得
      next_view_movies = all_movies[all_movies.index(last_viewed_movie) + 1..all_movies.index(all_movies.last)]

      # last_viewed_movieが最後のデータだったとき、next_view_moviesがカラになるのを防ぐ
      if next_view_movies.empty?
        next_view_movies = all_movies
      end
    end

    # 「観たい」「観た」「興味なし」に登録した映画を表示しない
    if current_user
      # current_userの映画ステータスデータを取得
      movie_statuses = current_user.movie_statuses
      # movie_statusesのmovie_idを配列に保存
      movie_status_id_array = []
      movie_statuses.size.times do |i|
        movie_status_id_array.push(movie_statuses[i]['movie_id'])
      end

      # movie_idの配列でwhere検索
      status_movies = Movie.where(id: movie_status_id_array)
    end

    if current_user.nil? # 未ログインユーザー
      if cookies['cinemat_movie_id'].nil?
        @movies = all_movies
      else
        @movies = next_view_movies
      end
    else # ログインユーザー
      if cookies['cinemat_movie_id'].nil?
        @movies = all_movies - status_movies
      else
        @movies = next_view_movies - status_movies
      end
    end
  end
end
