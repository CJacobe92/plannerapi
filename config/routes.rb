# frozen_string_literal: true

Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :auth
      resources :password_reset, param: :token, constraints: { token: /[^\/]+/ }
      resources :users do
        resources :categories do
          resources :tasks
        end
      end
    end
  end
end
