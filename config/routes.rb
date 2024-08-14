Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :documents, only: [:new, :create, :show]
end

