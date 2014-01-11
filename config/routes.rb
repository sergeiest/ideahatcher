Webapp::Application.routes.draw do



  resources :blogposts


  resources :funds


  post "likes/vote"
  resources :likes

  get "notifications/check_notification"
  resources :notifications

  post "circles/add_circle"
  post "circles/add_person"
  post "circles/remove_person"
  get "circles/send_access_request"
  get "circles/confirm_request"
  resources :circles

  post "tags/add_tag"
  post "tags/delete_tag"
  resources :tags

  resources :locations

  get "votes/vote_description"
  post "votes/vote_description"
  get "votes/show_votes"
  resources :votes

  get "ideas/show_idea"
  get "ideas/show_replies"
  resources :ideas

  resources :documents

  get "campaigns/guide_step"
  post "campaigns/next_step"
  get "campaigns/basic_step"
  post "campaigns/create_step"
  get "campaigns/about_step"
  post "campaigns/description_step"
  get "campaigns/circles_step"
  get "campaigns/publish_step"
  post "campaigns/upload_logo"
  post "campaigns/update_description"
  post "campaigns/update_name"

  #resources :campaigns

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
  post "authentications/update_password"
  resources :authentications

  post "pictures/upload_picture"
  post "pictures/edit_picture"
  post "pictures/delete_picture"
  resources :pictures

  post "companydescriptions/new_suggestion"
  post "companydescriptions/update_description"
  resources :companydescriptions

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
  get "investors/last_activities"
  post "investors/share_with_fund"
  post "investors/unshare_with_fund"
  resources :investors

  get "users/update"
  get "users/index"
  get "users/edit"
  get "users/change_password"
  get "users/notifications"

  post "colleagues/join_fund"
  post "colleagues/unjoin_fund"

  resources :users 

  get "startups/index"
  get "startups/team"
  get "startups/show"
  post "startups/search_startups"
  get "startups/circles"
  get "startups/dashboard"
  get "startups/hashtag"
  get "startups/my_ideas"
  get "startups/following_ideas"
  get "startups/show_more_startups"
  get "startups/request_access"
  post "startups/upload_link"
  resources :startups
  
  resources :peoples
  


  #get "home/index" => 'home#colorful'
  get "home/about"
  get "home/signup"
  get "home" => 'home#index'
  resources :home

  get "tri_valley_meetup" => 'tri_valley_meetup#signup'
  get "tri_valley_meetup/show"
  get "tri_valley_meetup/update_profile"
  get "tri_valley_meetup/profile"
  get "tri_valley_meetup/signup"
  get "tri_valley_meetup/add_to_fund"
  get "tri_valley_meetup/logout"
  post "tri_valley_meetup/wrong_login"
  post "tri_valley_meetup/delete_info"
  post "tri_valley_meetup/login"
  post "tri_valley_meetup/create_account"


  post "userinfos/add_experience"
  post "userinfos/add_ask"
  post "userinfos/delete_info"
  post "userinfos/delete_experience"
  post "userinfos/delete_ask"


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
