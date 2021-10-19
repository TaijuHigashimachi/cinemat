class MoviesController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    @movies = Movie.all.order(user_score: :desc)
  end
end
