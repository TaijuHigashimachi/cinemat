# Schema Information
#
# Table name: genres
#
# api_genre_id   :integer    not null uniqueness
# name           :string     not null uniqueness
# created_at     :datetime   not null
# updated_at     :datetime   not null
#

class Genre < ApplicationRecord
  has_many :movie_genres, dependent: :destroy
  has_many :movies, through: :movie_genres

  validates :api_genre_id, presence: true
  validates :name, presence: true, uniqueness: true
end
