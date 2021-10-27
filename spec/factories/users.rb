FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_name_#{n}"}
    sequence(:email) { |n| "#{n}@example.com" }
    password { 1234 }
    role { 0 }

    trait :admin do
      role { 1 }
    end
  end
end