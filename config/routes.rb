Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  root 'movies#index'
  
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  
  resources :movie_statuses, only: %i[create update destroy]
  resources :password_resets, only: %i[new create edit update]

  resources :users, only: %i[new create show edit update] do
    get '/watched', to: 'users#watched'
    get '/uninterested', to: 'users#uninterested'
  end

  namespace :admin do
    root 'movies#index'
    get 'movies/api_search', to: 'movies#api_search'
    
    resources :movies, only: %i[index create show edit update destroy] do
      collection do
        get '/search', to: 'movies#search'
      end
    end
    resources :genres, only: %i[index new create edit update destroy]
  end
end
