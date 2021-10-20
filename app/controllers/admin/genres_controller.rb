class Admin::GenresController < ApplicationController
  layout 'admin/layouts/application'

  before_action :admin_only

  def index
    @genres = Genre.all.order(id: :asc)
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to new_admin_genre_path, success: t('.success')
    else
      flash.now['danger'] = t('.fail')
      render :new
    end
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  private

  def genre_params
    params.require(:genre).permit(:api_genre_id, :name)
  end
end
