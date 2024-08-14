Rails.application.routes.draw do
  devise_for :users
  root 'documents#new'

  resources :documents, only: %i[new create show]
end
