Rails.application.routes.draw do
  root to: 'tops#index'
  resources :tasks
  namespace :admin do
    resources :users, only: %i[new create show]
  end
  resources :sessions, only: %i[new create destroy]
end
