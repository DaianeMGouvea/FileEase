# frozen_string_literal: true

require 'sidekiq/web'
Rails.application.routes.draw do
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users
  root 'documents#new'

  resources :documents, only: %i[new create show] do
    member do
      get :export_to_excel
    end
  end
end
