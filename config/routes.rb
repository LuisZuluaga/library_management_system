Rails.application.routes.draw do
  get 'borrowings/index'
  get 'borrowings/create'
  get 'borrowings/destroy'
  devise_for :users

  root to: 'home#index'

  get 'dashboard', to: 'dashboard#index'

  namespace :api do
    namespace :v1 do
      resources :books
      resources :borrowings, only: [:index, :create] do
        member do
          patch :return # /borrowings/:id/return
        end
      end
    end
  end
end

