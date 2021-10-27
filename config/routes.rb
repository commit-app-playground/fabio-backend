Rails.application.routes.draw do
  root to: 'accounts#index'
  resources :accounts do
    resources :bills
  end
end
