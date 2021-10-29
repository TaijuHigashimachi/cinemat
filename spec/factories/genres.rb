FactoryBot.define do
  factory :genre do
    sequence(:api_genre_id) { |n| "api_genre_id_#{n}" }
    sequence(:name) { |n| "genre_name_#{n}" }
  end
end