class MoviesController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    if cookies['cinemat']
      # ブラウザを閉じる前に観ていた映画を取得
      last_viewed_movie = Movie.find(cookies['cinemat'].to_i)
      # 全映画をユーザースコア順に並べて取得
      all_movies = Movie.all.order(user_score: :desc)
      # 全映画の中から、ブラウザを閉じる前に観ていた映画の次の映画から、最後のデータまで取得
      @movies = all_movies[all_movies.index(last_viewed_movie) + 1..all_movies.index(all_movies.last)]
    else
      # 全映画をユーザースコア順に並べて取得
      @movies = Movie.all.order(user_score: :desc)
    end
  end
end
