Rails.application.routes.draw do

  get 'range_menu/index'

  resources :data_correlations

  resources :data_types

  resources :data_points

  get 'data_menu/index'

  resources :time_slices

  resources :states

  resources :posts

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  get 'data_menu/:data_id/pick_range/:num,:num2/pick_correlation/:data_id2/data' => 'data_menu#data', as: :data
  get 'data_menu/:data_id/pick_range/:num,:num2/pick_correlation/:data_id2/draw_graph' => 'data_menu#draw_graph', as: :draw_graph
  get 'data_menu/:data_id/pick_range/:num,:num2/pick_correlation' => 'data_menu#pick_correlation', as: :pick_correlation
  get 'data_menu/:data_id/pick_range' => 'data_menu#pick_range', as: :pick_range
  get 'data_menu/:data_id/pick_range_submit' => 'data_menu#pick_range_submit', as: :pick_range_submit
  get 'data_menu/pick_data_submit' => 'data_menu#pick_data_submit'
  get 'data_menu/pick_correlation' => 'data_menu#pick_correlation'
  get 'data_menu/pick_data' => 'data_menu#pick_data'
  get 'data_menu' => 'data_menu#pick_data'
  get 'data_menu/index' => 'data_menu#index'
  get 'graph/index' => 'graph#index'
  get 'graph/' => 'graph#index'
  get 'graph/data' => 'graph#data'

  #resources :graph

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
