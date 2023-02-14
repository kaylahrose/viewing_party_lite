Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'landing#index'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  delete '/logout', to: 'users#destroy'
  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login_user'

  get '/users/:id/movies/:movie_id', to: 'movies#show'
  get '/users/:id/movies/:movie_id/viewing-party/new', to: 'viewing_parties#new'
  get '/users/:id/movies', to: 'movies#index'

  post '/users/:id/movies/:movie_id/viewing-party', to: 'viewing_parties#create'

  resources :users, only: %i[show new create] do
    get 'discover', on: :member
  end
end
