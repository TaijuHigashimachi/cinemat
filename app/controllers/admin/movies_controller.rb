class Admin::MoviesController < Admin::BaseController
  include Pagy::Backend
  require 'net/http'
  require 'uri'
  require 'json'

  before_action :set_movie, only: %i[show edit update destroy]
  before_action :set_q, only: %i[index search]
  before_action :set_search_result, only: %i[api_search]

  def index
    @pagy, @movies = pagy(Movie.all.order(user_score: :desc))
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to admin_movies_api_search_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :api_search
    end
  end

  def show; end

  def edit; end

  def update
    if @movie.update(movie_params)
      redirect_to edit_admin_movie_path(@movie), success: t('.success')
    else
      render :edit, danger: t('.fail')
    end
  end

  def destroy
    @movie.destroy!
    redirect_to admin_movies_path, success: t('.success')
  end

  def search
    @movies = @q.result.order(user_score: :desc)
  end

  def api_search
    return if @search_result['results'].nil?

    detail_url = "https://api.themoviedb.org/3/movie/#{@search_result['results'][0]['id']}?api_key=fffa263e9395a32c7352e5ee7a5b8df3&language=ja-JP&append_to_response=videos"
    detail_uri = URI.parse(detail_url)
    detail_json = Net::HTTP.get(detail_uri)
    @detail_result = JSON.parse(detail_json)

    @movie = Movie.new(api_id: @detail_result['id'],
                          title: @detail_result['title'],
                          runtime: @detail_result['runtime'],
                          user_score: @detail_result['vote_average'] * 10,
                          release_date: @detail_result['release_date'],
                          overview: @detail_result['overview'],
                          poster_url: @detail_result['poster_path'])
    @movie.trailer_url = @detail_result['videos']['results'][0]['key'] if @detail_result['videos']['results'][0]

    3.times { @movie.movie_genres.build }
  end

  private

  def movie_params
    params.require(:movie).permit(:api_id,
                                  :title,
                                  :runtime,
                                  :user_score,
                                  :release_date,
                                  :overview,
                                  :poster_url,
                                  :trailer_url,
                                  movie_genres_attributes: %i[id movie_id genre_id])
  end

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def set_q
    @q = Movie.ransack(params[:q])
  end

  def set_search_result
    query = URI.encode_www_form(q: params[:user_input].to_s).delete_prefix('q=')
    url = "https://api.themoviedb.org/3/search/movie?api_key=fffa263e9395a32c7352e5ee7a5b8df3&language=ja-JP&page=1&query=#{query}"
    uri = URI.parse(url)
    json = Net::HTTP.get(uri)
    @search_result = JSON.parse(json)
  end
end
