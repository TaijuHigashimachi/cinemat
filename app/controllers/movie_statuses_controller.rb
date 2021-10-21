class MovieStatusesController < ApplicationController
  def create
    movie = Movie.find(params[:movie_id])
    MovieStatus.create!(movie_id: movie.id, user_id: current_user.id, status: params[:status])
    redirect_back fallback_location: root_path
  end

  def destroy
    movie = current_user.movie_statuses.find(params[:id]).movie
    MovieStatus.destroy!(movie_id: movie.id, user_id: current_user.id)
    redirect_back fallback_location: root_path
  end
end
