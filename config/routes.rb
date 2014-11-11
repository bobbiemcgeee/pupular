Rails.application.routes.draw do

  resources :users
  resources :dogs do
    resources :messages
    resources :friends
    resources :profiles
  end

  post '/login' => "users#login"
  get '/retrieve_message_count' => "messages#retrieve_message_count"
  get '/check_for_new_message' => "messages#check_for_new_message"
  get '/all_dogs' => "dogs#all_dogs"
  get '/friend_list' => "friends#friend_list"
  get '/messages' => "messages#all_messages"
  get '/profile' => "dogs#profile"
  get '/new_message' => "messages#create"
  get '/friend_request' => "friends#friend_request"
  get '/accept_request' => "friends#accept_request"
  get '/conversation' => "messages#conversation"
  post '/upload_photo' => "profiles#add_photo"
  post '/sign_up' => "users#sign_up"
  get '/view_photo' => "profiles#view_photo"
  get '/test' => "users#test"
  get '/sign_up' => "users#sign_up"
  get '/retrieve_profile_photo' => "dogs#retrieve_profile_photo"
  get '/update_coordinates' => "users#update_coordinates"
  get '/deactivate' => "users#deactivate"
  get '/retrieve_active_friends' => "users#retrieve_active_friends"
  get '/walk_alert' => "messages#walk_alert"
  get '/dog_photo' => "dogs#dog_photo"
  get '/decline_request' => "friends#decline_request"
  get '/has_been_read' => "messages#has_been_read"
  get '/delete_message' => "messages#delete_message"
  get '/is_friend' => "friends#is_friend"
  get '/delete_friendship' => "friends#delete_friendship"
  post '/edit_profile' => "profiles#edit_profile"
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
