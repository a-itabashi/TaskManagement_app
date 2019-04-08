Rails.application.routes.draw do
  get 'labels/new'
  get 'labels/index'
  root to: 'tops#index'
  resources :tasks
  namespace :admin do
    resources :users
  end
  resources :users
  resources :sessions, only: %i[new create destroy]
end
