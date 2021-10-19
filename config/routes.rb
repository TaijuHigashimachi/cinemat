Rails.application.routes.draw do
  root 'movies#index'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[new create show edit update]

  namespace :admin do
    root 'movies#index'

    get 'movies/search', to: 'movies#search'

    resources :movies, only: %i[index create show edit update destroy]
    resources :genres, only: %i[index new create edit update destroy]
  end
end
