Rails.application.routes.draw do
  resources :teams
  resources :matches
  resources :leagues
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
