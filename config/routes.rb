Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :accounts, controllers: { registrations: "accounts/registrations" }

  namespace :account do
    get ":account_id/dashboard" => "urls#index", as: :dashboard
    root "urls#index"
    resources :urls, only: %i[index create edit update destroy], param: :short_url
  end

  root "urls#index"
  resources :urls, only: %i[index create]
  get "/:short_url", to: "urls#redirect", as: :short

  # Defines the root path route ("/")
  # root "posts#index"
end
