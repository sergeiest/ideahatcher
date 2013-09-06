Webapp::Application.routes.draw do

  post "likes/vote"
  resources :likes


  get "notifications/check_notification"
  resources :notifications


  post "circles/add_circle"
  post "circles/add_person"
  post "circles/remove_person"


  post "tags/add_tag"
  post "tags/delete_tag"
  resources :tags


  resources :locations


  get "votes/vote_description"
  post "votes/vote_description"
  get "votes/show_votes"
  resources :votes


  get "ideas/show_idea"
  get "ideas/idea_test"
  resources :ideas


  resources :documents


  get "campaigns/guide_step"
  get "campaigns/basic_step"
  get "campaigns/about_step"
  get "campaigns/team_step"
  post "campaigns/next_step"
  post "campaigns/create_step"
  post "campaigns/description_step"
  post "campaigns/team_save_step"
  post "campaigns/upload_logo"
  get "campaigns/publish_step"
  post "campaigns/update_description"
  post "campaigns/update_name"
  get "campaigns/circles_step"
  resources :campaigns

  get "authentications/login"
  post "authentications/remote_login"
  post "authentications/create"
  get "authentications/wrong_link"
  get "authentications/forgot_password"
  post "authentications/forgot_password"
  get "authentications/new"
  get "authentications/logout"
  get "authentications/checklogin"
  post "authentications/process_login"
  post "authentications/demo_login"
  get "authentications/login_join"
  post "authentications/update_password"
  get "authentications/join_login_form"
  resources :authentications

  resources :pictures

  post "companydescriptions/new_suggestion"
  post "companydescriptions/update_description"
  resources :companydescriptions

  get "funds/approval"
  get "funds/update"
  post "funds/update"
  resources :funds
  resources :companydocuments

  get "companydocs/uploaddoc"
  post "companydocs/uploadfile"
  resources :companydocs

  resources :companyupdates

  get "investors/unfollowcompany"
  get "investors/follow_company"
  get "investors/add_mentor"
  get "investors/delete_mentor"
  get "investors/people"
  get "investors/newstartup"
  get "investors/history_startup"
  post "investors/search_people"
  post "investors/add_founder"
  post "investors/remove_founder"
  get "investors/confirm_founder"
  get "investors/follower_info"
  resources :investors

  get "users/login"
  get "users/update"
  post "users/process_login"

  get "users/logout"
  get "users/my_account"
  get "users/new"
  get "users/index"
  get "users/edit"
  get "users/invest"
  get "users/ideas"
  get "users/ideas_more"
  get "users/change_password"
  get "users/notifications"

  resources :users 

  get "startups/index"
  get "startups/documents"
  get "startups/mentors"
  get "startups/detailed"
  get "startups/team"
  get "startups/developermode"
  get "startups/newlook"
  get "startups/show"
  get "startups/update"
  post "startups/search_startups"
  post "startups/vote_like"
  post "startups/vote_not_clear"
  post "startups/vote_dislike"
  get "startups/vote_lightning"
  get "startups/vote_next"
  get "startups/circle"
  get "startups/dashboard"
  get "startups/idea_hatching"
  get "startups/hashtag"
  get "startups/followers"
  get "startups/my_ideas"
  get "startups/following_ideas"
  get "startups/show_more_startups"
  get "startups/new_view"
  get "startups/new_view_index"
  resources :startups
  
  resources :peoples
  


  get "home/index" => 'home#colorful'
  get "home/about"
  get "home" => 'home#index'
  resources :home


  root :to => 'home#index'


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
