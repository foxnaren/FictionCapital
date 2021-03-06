require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :users

  resources :examples
  resources :lightnovels do 
      resources :chapters    
  end
  get '/lightnovel/:id/follow' => 'lightnovels#follow', as: :follow_lightnovel
  get '/lightnovel/:id/unfollow' => 'lightnovels#unfollow', as: :unfollow_lightnovel
  
  get "/home" => "lightnovels#home", as: :home

    root 'lightnovels#home'

  get "/unread" => "lightnovels#unread", as: :unreads
  get "/followed" => "lightnovels#followed", as: :followed 
  get "/render_chapter" => "lightnovels#render_chapter", as: :render_chapter 
  get "/mark_as_read" => "lightnovels#mark_as_read", as: :mark_as_read 
  
  

  mount Sidekiq::Web, at: '/sidekiq'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
