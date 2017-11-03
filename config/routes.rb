Rails.application.routes.draw do
  root "pages#home"
  resource :subcribers
  resources :products, only: [:show, :index] do
    member do
      get :order
      post :send_order
    end
  end
  resources :blogs, only: [:show, :index]
  resources :medias, only: [:show, :index]
  resources :contacts, only: [:index, :create]
  get "/products" => "products#index", as: :search_product

  namespace :admin do
    resources :home, only: [:show]
  end
end
