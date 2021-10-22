class MovieStatusesController < ApplicationController
  def create
    movie = Movie.find(params[:movie_id])
    MovieStatus.create!(movie_id: movie.id, user_id: current_user.id, status: params[:status])
    redirect_back fallback_location: root_path
  end

  def update
    @movie_status = MovieStatus.find_by(movie_id: params[:movie_id])
    @movie_status.update!(movie_status_params)
    redirect_back fallback_location: user_path(current_user)
  end

  def destroy
    MovieStatus.find_by(movie_id: params[:movie_id], user_id: params[:user_id]).destroy!
    redirect_back fallback_location: root_path
  end

  private

  def movie_status_params
    params.permit(:status)
  end
end
