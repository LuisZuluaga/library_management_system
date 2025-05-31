Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  get 'dashboard', to: 'dashboard#index'

  get 'books/new_form', to: 'books#create', as: :new_book_form

  namespace :api do
    namespace :v1 do
      resources :books
      resources :borrowings, only: [:index, :show, :create, :destroy] do
        member do
          patch :return # /borrowings/:id/return
        end
      end
    end
  end
end

