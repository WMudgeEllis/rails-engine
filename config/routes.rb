Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :items, only: [:index, :show, :create, :destroy, :update] do
        get '/merchant', to: 'item_merchant#show'
      end
      resources :merchants, only: [:index, :show] do
        get '/items', to: 'merchant_items#index'
      end
    end
  end
end
