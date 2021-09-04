Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :players, only: [:index]
  resources :player_exports, only: [:index, :create]
end
