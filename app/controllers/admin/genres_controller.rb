class Admin::GenresController < Admin::BaseController
  before_action :set_genre, only: %i[edit update destroy]
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

  def edit; end

  def update
    if @genre.update(genre_params)
      redirect_to admin_genres_path, success: t('.success')
    else
      render :edit, danger: t('.fail')
    end
  end

  def destroy
    @genre.destroy!
    redirect_to admin_genres_path, success: t('.success')
  end

  private

  def genre_params
    params.require(:genre).permit(:api_genre_id, :name)
  end

  def set_genre
    @genre = Genre.find(params[:id])
  end
end
