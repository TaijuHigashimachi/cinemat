FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}"}
    sequence(:email) { |n| "#{n}@example.com" }
    password { 123456 }
    password_confirmation { 123456 }
    role { 0 }

    trait :admin do
      role { 1 }
    end
  end
end