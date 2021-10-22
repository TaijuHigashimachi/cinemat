class MoviesController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    if cookies['cinemat']
      # ブラウザを閉じる前に観ていた映画を取得
      last_viewed_movie = Movie.find(cookies['cinemat'].to_i)
      # 全映画をユーザースコア順に並べて取得
      all_movies = Movie.all.order(user_score: :desc)
      # 全映画の中から、ブラウザを閉じる前に観ていた映画の次の映画から、最後のデータまで取得
      next_view_movies = all_movies[all_movies.index(last_viewed_movie) + 1..all_movies.index(all_movies.last)]

      # current_userが登録しているmovie_statusesのデータを取得
      movie_statuses = current_user.movie_statuses
      # movie_statusesのmovie_idを配列に保存
      movie_id_array = []
      movie_statuses.size.times do |i|
        movie_id_array.push(movie_statuses[i]['movie_id'])
      end
      # movie_idの配列でwhere検索
      status_movies = Movie.where(id: movie_id_array)
      
      # 次に観る映画の中から、movie_statusesテーブルに登録していた映画を除外する
      @movies = next_view_movies - status_movies
    else
      # 全映画をユーザースコア順に並べて取得
      @movies = Movie.all.order(user_score: :desc)
    end
  end
end
