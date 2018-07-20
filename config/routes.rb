Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  root "pages#home"
  resource :subcribers
  resources :products, only: [:show, :index] do
    member do
      get :order
      post :send_order
    end
  end

  get '/san-pham/:id' => 'products#show', as: :friendly_product

  resources :blogs, only: [:show, :index]
  resources :medias, only: [:show, :index]
  resources :contacts, only: [:index, :create]
  get "/products" => "products#index", as: :search_product

  namespace :admin do
    root "home#show"
    resources :home, only: [:show]
    resources :fields
    resources :brands
    resource :company, only: [:show, :update, :edit]
    resources :sliders
    resources :catalogs
    resources :products
    resources :categories
    resources :imports
    resources :tags
    resources :subscribers
    get "/edit_company" => "companies#edit", as: :edit_company
    resources :fields
    resources :medias
    devise_for :admins, :controllers => {:sessions => 'admin/sessions',
      :passwords => 'admin/passwords' }, path: '', path_names: { sign_in: 'login', sign_out: 'logout'}
    resources :blogs
    post "/templates/:id" => "templates#show", defaults: {format: "json"}, as: :template
    resources :templates, only: [:index, :create, :update, :destroy]
  end
end
