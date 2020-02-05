Rails.application.routes.draw do
  devise_for :users
  resources :dummy_models
end
