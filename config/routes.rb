Rails.application.routes.draw do
  get 'errors/file_not_found'
  get 'errors/unprocessable'
  get 'errors/internal_server_error'

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

  match "/404", to: "errors#file_not_found", via: :all
  match "/422", to: "errors#unprocessable'", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  get '/loai-san-pham/:category_id' => 'categories#index', as: :product_categories
  get '/danh-sach-san-pham/:category_id' => 'products#index', as: :category_products
  get '/linh-vuc/:field_id' => 'products#index', as: :product_field
  get '/hang-san-xuat/:brand_id' => 'products#index', as: :product_brand
  get '/tim-kiem' => 'products#index', as: :all_products
  get '/san-pham/:id' => 'products#show', as: :friendly_product
  get '/tin-tuc/:id' => 'blogs#show', as: :blog_detail
  get '/tin-tuc' => 'blogs#index', as: :blog_list

  resources :blogs, only: [:show, :index]
  get '/loai-tin-tuc/:blog_category_id' => 'blogs#index', as: :blog_list_category
  resources :medias, only: [:show, :index]
  get '/tai-lieu' => 'medias#index', as: :friendly_document
  get '/tai-lieu/:custom_category_id' => 'medias#index', as: :friendly_custom_category_document
  get '/video' => 'medias#index', as: :friendly_video
  get '/video/:custom_category_id' => 'medias#index', as: :friendly_custom_category_video

  resources :contacts, only: [:index, :create]
  get '/lien-he' => 'contacts#index', as: :friendly_contact

  namespace :admin do
    root "home#show"
    resources :home, only: [:show]
    resources :fields
    resources :projects
    resources :certificates
    resources :custom_categories
    resources :folders
    resources :brands
    resources :feedbacks
    resource :company, only: [:show, :update, :edit]
    resources :sliders
    resources :catalogs
    resources :categories
    resources :products
    resources :multiple_categories
    resources :home_categories, only: [:update, :edit]
    put "/product_quick_save/:product_id" => "products#quick_save", as: :product_quick_save
    delete "/products/destroy_multiple" => "products#destroy_multiple"
    get "/products_by_category/:category_id" => "multiple_categories#products_by_category", as: :products_by_category
    resources :imports
    resources :tags
    resources :subscribers
    get "/edit_company" => "companies#edit", as: :edit_company
    resources :fields
    resources :medias
    devise_for :admins, :controllers => {:sessions => 'admin/sessions',
      :passwords => 'admin/passwords' }, path: '', path_names: { sign_in: 'login', sign_out: 'logout'}
    resources :blogs do
      post 'bulk_delete', on: :collection
    end
    # post "/templates/:id" => "templates#show", defaults: {format: "json"}, as: :template
    # resources :templates, only: [:index, :create, :update, :destroy]
    resources :blog_categories
    resources :customer_orders, only: [:index, :destroy] do
      collection do
        post "bulk_delete"
        post "confirm_bulk_delete"
      end
      post "confirm_delete", on: :member
    end
  end
end
