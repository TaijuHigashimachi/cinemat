Rails.application.routes.draw do
  namespace :admin do
    resources :movies, only: %i[index]
  end

  root 'movies#index'
end
