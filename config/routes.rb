Rails.application.routes.draw do
  resources :photos, only: [:new, :create, :index]
  root to: 'photos#index'
end
