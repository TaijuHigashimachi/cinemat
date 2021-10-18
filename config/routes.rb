Rails.application.routes.draw do
  namespace :admin do
    get 'movies/search', to: 'movies#search'
    resources :movies, only: %i[index create show edit update destroy ]
    resources :genres, only: %i[index new create edit update destroy ]
  end

  root 'movies#index'
end
