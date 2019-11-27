Rails.application.routes.draw do
  resources :teams
  resources :matches
  resources :leagues
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "pages#home"
  get "premier_league/:matchday", to: "pages#premier_league"
  get "la_liga/:matchday", to: "pages#la_liga"
  get "ligue_1/:matchday", to: "pages#ligue_1"
  get "bundesliga/:matchday", to: "pages#bundesliga"
  get "serie_a/:matchday", to: "pages#serie_a"
end
