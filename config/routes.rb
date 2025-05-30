Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  get 'dashboard', to: 'dashboard#index'

  resources :books
end

