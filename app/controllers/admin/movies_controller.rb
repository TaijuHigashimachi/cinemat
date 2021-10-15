class Admin::MoviesController < ApplicationController
  before_action :set_movie, only: %i[show edit update destroy]
  layout 'admin/layouts/application'

  require 'net/http'
  require 'uri'
  require 'json'

  
  def index
    @movies = Movie.all
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to admin_movies_search_path, success: '映画を登録しました'
    else
      render :search, danger: '映画の登録に失敗しました'
    end
  end

  def show; end

  def edit; end

  def update
    if @movie.update_attributes(movie_params)
      redirect_to edit_admin_movie_path(@movie), success: '映画を更新しました'
    else
      render :edit, danger: '映画の更新に失敗しました'
    end
  end

  def destroy
    @movie.destroy!
    redirect_to  admin_movies_path, success: '映画を削除しました'
  end

    def search
    if params[:user_input].present?
      query = URI.encode_www_form(q: "#{params[:user_input]}").delete_prefix('q=')
      url = "https://api.themoviedb.org/3/search/movie?api_key=fffa263e9395a32c7352e5ee7a5b8df3&language=ja-JP&page=1&query=#{query}"
      uri = URI.parse("#{url}")
      json = Net::HTTP.get(uri)
      result = JSON.parse(json)
  
      detail_url = "https://api.themoviedb.org/3/movie/#{result['results'][0]['id']}?api_key=fffa263e9395a32c7352e5ee7a5b8df3&language=ja-JP&append_to_response=videos"
      detail_uri = URI.parse("#{detail_url}")
      detail_json = Net::HTTP.get(detail_uri)
      @detail_result = JSON.parse(detail_json)

      @movie = Movie.new
      @movie.api_id = @detail_result['id']
      @movie.title = @detail_result['title']
      @movie.trailer_url = @detail_result['videos']['results'][0]['key']
      @movie.release_date = @detail_result['release_date']
      @movie.user_score = @detail_result['vote_average'].to_i * 10
      @movie.overview = @detail_result['overview']
      @movie.poster_url = @detail_result['poster_path']

      3.times{
        @movie.movie_genres.build
      }
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:api_id, :title, :trailer_url, :release_date, :user_score, :overview, :poster_url, movie_genres_attributes: [:id, :movie_id, :genre_id])
  end

  def set_movie
    @movie = Movie.find(params[:id])
  end
end
