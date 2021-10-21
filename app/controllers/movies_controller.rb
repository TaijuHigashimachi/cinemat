class MoviesController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    if cookies['cinemat']
      view_history = cookies['cinemat']
      last_views_movie = Movie.find(view_history.to_i)
      next_movie = last_views_movie.next
      all_movies = Movie.all.order(user_score: :desc)
      @movies = all_movies[all_movies.index(next_movie)..all_movies.index(all_movies.last)]
    else
      @movies = Movie.all.order(user_score: :desc)
    end
  end
end
