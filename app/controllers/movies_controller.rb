class MoviesController < ApplicationController
  def index
    @movies = Movie.all.order(user_score: :desc)
  end
end
