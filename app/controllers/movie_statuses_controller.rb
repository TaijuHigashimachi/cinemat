class MovieStatusesController < ApplicationController
  def create
    movie = Movie.find(params[:movie_id])
    MovieStatus.create!(movie_id: movie.id, user_id: current_user.id, status: params[:status])
    redirect_back fallback_location: root_path
  end

  def destroy
    byebug
    MovieStatus.find_by(movie_id: params[:movie_id], user_id: params[:user_id]).destroy!
    redirect_back fallback_location: root_path
  end
end
