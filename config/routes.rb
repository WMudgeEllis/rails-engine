Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/items/find', to: 'items#find'
      resources :items, only: [:index, :show, :create, :destroy, :update] do
        get '/merchant', to: 'item_merchant#show'
      end
      get '/merchants/find_all', to: 'merchants#find'
      resources :merchants, only: [:index, :show] do
        get '/items', to: 'merchant_items#index'
      end
      get '/revenue/merchants/:id', to: 'revenue#merchant_revenue'
      get '/revenue/merchants', to: 'revenue#merchant_revenue_list'
      get '/revenue/unshipped', to: 'revenue#unshipped_revenue'
      get '/revenue/items', to: 'revenue#item_revenue_list'
    end
  end
end
