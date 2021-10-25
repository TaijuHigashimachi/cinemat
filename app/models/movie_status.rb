class MovieStatus < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  enum status: { watch: 0, watched: 1, uninterested: 2 }
end
