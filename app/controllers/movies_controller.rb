class MoviesController < ApplicationController
  def index
    # 全映画をユーザースコア順に並べて取得
    all_movies = Movie.all.order(user_score: :desc)
    # ブラウザを開き直したとき、最後に観た映画の次の映画から表示
    next_view_movies = if cookies['cinemat_movie_id']
                         # ブラウザを閉じる前、最後に観ていた映画を取得
                         last_viewed_movie = Movie.find(cookies['cinemat_movie_id'].to_i)
                         # 全映画の中から、last_viewed_movieの次から最後までのデータを取得
                         all_movies[all_movies.index(last_viewed_movie) + 1..all_movies.index(all_movies.last)]
                       end

    # last_viewed_movieが最後のデータだったとき、next_view_moviesがカラになるのを防ぐ
    next_view_movies = all_movies if next_view_movies.blank?

    # 「観たい」「観た」「興味なし」に登録した映画を表示しない
    status_movies = if current_user
                      # current_userの映画ステータスデータを取得
                      movie_statuses = current_user.movie_statuses
                      # movie_statusesのmovie_idを配列に保存
                      movie_status_id_array = movie_statuses.map { |i| i['movie_id'] }

                      # movie_idの配列でwhere検索
                      Movie.where(id: movie_status_id_array)
                    end

              # 未ログインユーザー x クッキーなし
    @movies = if current_user.nil? && cookies['cinemat_movie_id'].nil?
                all_movies
              # 未ログインユーザー x クッキーあり
              elsif current_user.nil? && cookies['cinemat_movie_id'].present?
                next_view_movies
              # ログインユーザー x クッキーなし
              elsif current_user && cookies['cinemat_movie_id'].nil?
                all_movies - status_movies
              # ログインユーザー x クッキーあり
              elsif current_user && cookies['cinemat_movie_id'].present?
                next_view_movies - status_movies
              end
  end
end
