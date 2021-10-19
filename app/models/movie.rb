# Schema Information
#
# Table name: movies
#
# api_id         :integer    not null uniqueness
# title          :string     not null uniqueness
# trailer_url    :string     not null uniqueness
# poster_url     :string     not null
# release_date   :date       not null
# user_score     :float      not null
# orverview      :text       not null
# created_at     :datetime   not null
# updated_at     :datetime   not null
#

class Movie < ApplicationRecord
  has_many :movie_genres, dependent: :destroy
  has_many :genres, through: :movie_genres
  accepts_nested_attributes_for :movie_genres, allow_destroy: true

  validates :api_id, presence: true, uniqueness: true
  validates :title, presence: true, uniqueness: true
  validates :trailer_url, presence: true, uniqueness: true
  validates :poster_url , presence: true, uniqueness: true
  validates :release_date , presence: true, uniqueness: true
end
