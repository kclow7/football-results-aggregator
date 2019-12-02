Rails.application.routes.draw do
  resources :teams
  resources :matches
  resources :leagues
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "pages#home", as: :home

  get "premier_league", to: "pages#premier_league", as: :premier_league
  get "premier_league/:matchday", to: "pages#premier_league", as: :premier_league_with_matchday

  get "la_liga", to: "pages#la_liga", as: :la_liga
  get "la_liga/:matchday", to: "pages#la_liga", as: :la_liga_with_matchday

  get "ligue_1", to: "pages#ligue_1", as: :ligue_1
  get "ligue_1/:matchday", to: "pages#ligue_1", as: :ligue_1_with_matchday

  get "bundesliga", to: "pages#bundesliga", as: :bundesliga
  get "bundesliga/:matchday", to: "pages#bundesliga", as: :bundesliga_with_matchday

  get "serie_a", to: "pages#serie_a", as: :serie_a
  get "serie_a/:matchday", to: "pages#serie_a", as: :serie_a_with_matchday

  get "something_is_wrong", to: "pages#something_is_wrong", as: :something_is_wrong

end
