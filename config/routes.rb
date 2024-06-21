Rails.application.routes.draw do
  root 'forums#index'

  resources :sessions

  resources :users do
    resources :posts
    resources :moderators
  end

  post '/users/:id/admin', as: 'admin_user', to: 'users#admin'

  resources :forums do
    resources :posts
    resources :topics do
      resources :posts, :monitorships
    end
  end

  resource :blacklist, controller: 'blacklist'

  # Fake DELETE requests to the monitorships controller result in a
  # routing error with default Beast routes.
  #
  get '/forums/:forum_id/topics/:topic_id/monitorships/destroy', to: 'monitorships#destroy'

  get '/posts/search', as: :search_all_posts, to: 'posts#search'
  resources :posts, as: 'all_posts'

  get '/signup',        as: :signup,   to: 'users#new'
  get '/settings',      as: :settings, to: 'users#edit'
  get '/activate/:key', as: :activate, to: 'users#activate'
  get '/login',         as: :login,    to: 'sessions#new'
  get '/logout',        as: :logout,   to: 'sessions#destroy'

  get '/users/:user_id/monitored', as: :monitored_posts, to: 'posts#monitored'

  # Old-fashioned route for backwards compatibility with RForum's
  # global feed location
  #
  get '/feed/global', controller: 'posts', action: 'index_rss'
end
