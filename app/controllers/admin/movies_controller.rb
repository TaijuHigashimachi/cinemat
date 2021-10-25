class Admin::MoviesController < ApplicationController
  layout 'admin/layouts/application'

  include Pagy::Backend
  require 'net/http'
  require 'uri'
  require 'json'

  before_action :admin_only
  before_action :set_movie, only: %i[show edit update destroy]
  before_action :set_q, only: %i[index search]

  def index
    @pagy, @movies = pagy(Movie.all.order(user_score: :desc))
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to admin_movies_api_search_path, success: t('.success')
    else
      render :api_search, danger: t('.fail')
    end
  end

  def show; end

  def edit; end

  def update
    if @movie.update_attributes(movie_params)
      redirect_to edit_admin_movie_path(@movie), success: t('.success')
    else
      render :edit, danger: t('.fail')
    end
  end

  def destroy
    @movie.destroy!
    redirect_to  admin_movies_path, success: t('.success')
  end

  def search
    @movies = @q.result.order(user_score: :desc)
  end

  def api_search
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
      @movie.runtime = @detail_result['runtime']
      @movie.user_score = @detail_result['vote_average'] * 10
      @movie.release_date = @detail_result['release_date']
      @movie.overview = @detail_result['overview']
      @movie.poster_url = @detail_result['poster_path']
      @movie.trailer_url = @detail_result['videos']['results'][0]['key']

      3.times{
        @movie.movie_genres.build
      }
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:api_id, :title, :runtime, :user_score, :release_date, :overview, :poster_url, :trailer_url, movie_genres_attributes: [:id, :movie_id, :genre_id])
  end

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def set_q
    @q = Movie.ransack(params[:q])
  end
end
