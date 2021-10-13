class Admin::MoviesController < ApplicationController
  layout 'admin'

  require 'themoviedb-api'
  Tmdb::Api.key("fffa263e9395a32c7352e5ee7a5b8df3")
  Tmdb::Api.language("ja") # こちらで映画情報の表示の際の言語設定を日本語にできます

  def index
  end

  def search
  end

  def show
  end
end
