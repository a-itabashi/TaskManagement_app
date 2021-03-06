Rails.application.routes.draw do
  root to: 'tops#index'
  resources :tasks
  namespace :admin do
    resources :users
  end
  resources :users
  resources :sessions, only: %i[new create destroy]
  resources :labels
  resources :groups
  resources :assigns, only: %i[create destroy]

  mount LetterOpenerWeb::Engine, at: "/letter_opener"

end
