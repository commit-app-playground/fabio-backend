Rails.application.routes.draw do
  root to: 'accounts#index'
  resources :accounts do
    resources :bills, shallow: true do
      resource :bill_payment, shallow: true
    end
  end
end
