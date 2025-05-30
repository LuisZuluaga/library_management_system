Rails.application.routes.draw do
  get 'borrowings/index'
  get 'borrowings/create'
  get 'borrowings/destroy'
  devise_for :users

  root to: 'home#index'

  get 'dashboard', to: 'dashboard#index'

  resources :books
  resources :borrowings, only: [:index, :create, :destroy]
end

