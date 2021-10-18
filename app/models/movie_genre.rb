# == Schema Information
#
# == Table name: movie_genres
#
# movie_id     :bigint     not null
# genre_id     :bigint     not null
# created_at   :datetime   not null
# updated_at   :datetime   not null
#
# == Indexes
#
# index_movie_genres_on_movie_id
# index_movie_genres_on_genre_id
#

class MovieGenre < ApplicationRecord
  belongs_to :movie
  belongs_to :genre

  # validates :movie_id, presence: true
  validates :genre_id, presence: true
end
