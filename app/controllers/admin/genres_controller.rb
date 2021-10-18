class Admin::GenresController < ApplicationController
  layout 'admin/layouts/application'

  def index
    @genres = Genre.all.order(id: :asc)
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to new_admin_genre_path, success: 'ジャンルを作成しました'
    else
      flash.now['danger'] = 'ジャンルを作成できませんでした'
      render :new
    end
  end

  private

  def genre_params
    params.require(:genre).permit(:api_genre_id, :name)
  end
end
