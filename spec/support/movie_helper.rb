module MovieHelper
  def best_score_movie
    orderd_movie.limit(1)[0]
  end

  def second_best_score_movie
    orderd_movie.limit(2)[1]
  end

  def third_best_score_movie
    orderd_movie.limit(3)[2]
  end

  private

  def orderd_movie
    Movie.order(user_score: :desc)
  end
end