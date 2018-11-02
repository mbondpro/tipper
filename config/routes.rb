Tipper::Application.routes.draw do

  devise_for :users
  resources :users

  resources :companies
  resources :services
  resources :treatments
  resources :customers

  match 'search' => 'customers#search'
  match 'reports' => 'reports#index'

  root :to => 'home#index'

end
