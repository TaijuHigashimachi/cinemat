FactoryBot.define do
  factory :movie do
    sequence(:api_id) { |n| "api_id_#{n}" }
    sequence(:title) { |n| "movie_title_#{n}" }
    sequence(:runtime) { |n| n }
    sequence(:user_score) { |n| n }
    sequence(:release_date) { |n| "2021-01-01" }
    sequence(:overview) { |n| "movie_orver_view_#{n}" }
    poster_url { 'aWgsQirjOeE8lAw7lTL5darxzQb.jpg' }
    trailer_url { '0UkG8GnfCCY' }

    after(:create) do |movie|
      create_list(:movie_genre, 3, movie: movie, genre: create(:genre))
    end
  end
end
