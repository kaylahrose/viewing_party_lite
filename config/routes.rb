Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'landing#index'

  resources :users, only: %i[new create], path: '/register'
  resources :users, only: %i[show new create] do
    get 'discover', on: :member
    # resources :movies, only: [:show, :index], on: :member, as: '/results'
  end
end
