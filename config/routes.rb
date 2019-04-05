Rails.application.routes.draw do
  root to: 'tops#index'
  resources :tasks
  resources :users, only: %i[new create show]
  resources :sessions, only: %i[new create destroy]
end
