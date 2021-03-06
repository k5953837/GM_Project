Rails.application.routes.draw do
  devise_for :users
  namespace :admin do
    resources :products
    resources :orders do
      member do         # 自定對特定元素的Action
        post :cancel    # admin/orders#cancel
        post :ship      # admin/orders#ship
        post :shipped   # admin/orders#shipped
        post :return    # admin/orders#return
      end
    end
  end

  resources :products do
    member do
      # Specify path for add_to_cart_product_path
      post :add_to_cart
    end
  end

  resources :carts do
    # checkout is a self-defined path.
    # checkout_carts POST   /carts/checkout(.:format)           carts#checkout
    post "checkout", on: :collection
    delete "clean", on: :collection
  end

  resources :orders do
    member do
      get :pay_with_credit_card
    end
  end

  resources :items, controller: "cart_items"

  namespace :account do
    resources :orders
  end

  root "products#index"

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
