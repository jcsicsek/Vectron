Vectron::Application.routes.draw do
  
  devise_for :admins
  
  match '/save_preferences', :to => 'landing#save_preferences'
  match '/preferences', :to => 'landing#preferences'
  match '/admin/activate_business', :to => 'admin#activate_business'
  
  match '/quick_signin', :to => 'user#quick_signin'
  match '/signin_and_checkout', :to => 'vouchers#signin_and_checkout'
  
  match '/location/delete', :to => 'business#delete_location'
  match '/location/edit', :to => 'business#edit_location'
  match '/location/save', :to => 'business#save_location'
  match '/location/save_and_add', :to => 'business#save_and_add_location'
  
  match '/promo/:name', :to => 'landing#promo'
  match '/new-york-city', :to => 'user#home', :as => :user_root
  match '/new-york-city', :to => 'user#home', :as => :home
  
  match '/unsubscribe', :to => 'landing#unsubscribe'

  match '/admin', :to => 'admin#home'
  match '/admin/business/signin', :to => 'admin#business_signin'
  
  match '/business/delete_payment_profile', :to => 'business#delete_payment_profile'
  
  match '/print/:id', :to => 'print#voucher'
  match '/print/dashboard/:id', :to => 'print#event_dashboard'
  match '/delete_payment_profile', :to => 'user#delete_payment_profile'
  match '/paypal_express_buy', :to => 'vouchers#paypal_express_buy'
  match '/paypal_callback', :to => 'vouchers#paypal_callback'
  match '/facebook_registration', :to => 'user#facebook_registration'
  
  match '/template/update', :to => 'vouchers#update_template'
  match '/event/delete', :to => 'vouchers#delete'
  match '/template/delete', :to => 'vouchers#delete_template'
  match '/template/:id', :to => 'vouchers#event_template_modify'
  match '/event', :to => 'vouchers#business_event_modify'

  match '/user', :to => 'user#home'
  match '/business', :to => 'business#landing'
  
  match '/businesses/new', :to => 'business#signup'
  #match '/users/sign_in' => 'user#login'

  devise_for :businesses

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "user_registrations" }
  
  devise_scope :user do
    match '/users/logout' => 'devise/sessions#destroy'
    #match '/users/login' => 'devise/sessions#new'
  end
  
  devise_scope :business do match '/business/logout' => 'devise/sessions#destroy' end
  
  #namespace :user do
    #root :to => "user#home"
    #match '/signin', :to => 'user#login'
  #end
  
  namespace :business do
    root :to => "business#account"
    match '/signin', :to => 'business#login'
  end
  
  namespace :admin do
    root :to => "admin#home"
  end
  
  root :to => 'landing#show'
  
  match '/landing', :to => 'landing#show'
  match '/subscriber/create', :to => 'landing#create_subscriber'
  
  if Rails.env.production?
  
  # User stuff...
  # UserController
  #TODO:  Clean up redundant routes (has huge implications for URLs scattered around views, controllers...)
  match '/home', :to => 'user#home'
  match '/account', :to => 'user#account', :constraints => { :protocol => "https" }
  match "account(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  
  match '/signup', :to => 'user#signup', :constraints => { :protocol => "https" }
  match "signup(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/login', :to => 'user#login', :constraints => { :protocol => "https" }
  match "login(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/users/login', :to => 'user#login', :constraints => { :protocol => "https" }
  match "users/login(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/users/new', :to => 'user#signup', :constraints => { :protocol => "https" }
  match "users/new(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/user/login', :to => 'user#login', :constraints => { :protocol => "https" }
  match "user/login(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/user/new', :to => 'user#signup', :constraints => { :protocol => "https" }
  match "user/new(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/users/logout', :to => 'devise/sessions#destroy'
  match '/user/logout', :to => 'devise/sessions#destroy'
  match '/user', :to => 'user#home'
  match '/user/update', :to => 'user#update', :constraints => { :protocol => "https" }
  match "user/update(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/user/change_password', :to => 'user#change_password', :constraints => { :protocol => "https" }
  match "user/change_password(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  
  #User Payment Stuff
  match '/create_payment_profile', :to => 'user#create_payment_profile', :constraints => { :protocol => "https" }
  match "create_payment_profile(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/user/set_default_payment', :to => 'user#set_default_payment', :constraints => { :protocol => "https" }
  match "user/set_default_payment(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  
  # Business stuff...
  # BusinessController
  match '/business/landing', :to => 'business#landing'
  match '/business/login', :to => 'business#login', :constraints => { :protocol => "https" }
  match "business/login(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  #match '/business', :to => 'business#account', :constraints => { :protocol => "https" }
  #match "business(/*path)", :to => redirect { |_, request|
  #  "https://" + request.host_with_port + request.fullpath }
  match '/business/update', :to => 'business#update', :constraints => { :protocol => "https" }
  match "business/update(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/business/account', :to => 'business#account', :constraints => { :protocol => "https" }
  match "business/account(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/business/new', :to => 'business#signup', :constraints => { :protocol => "https" }
  match "business/new(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/business/signup', :to => 'business#signup', :constraints => { :protocol => "https" }
  match "business/signup(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/business/logout', :to => 'devise/sessions#destroy'
  match '/business/set_default_payment', :to => 'business#set_default_payment', :constraints => { :protocol => "https" }
  match "business/set_default_payment(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/business/change_password', :to => 'business#change_password', :constraints => { :protocol => "https" }
  match "business/change_password(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  
  # Business Payment Profile stuff...
  # NOT to be confused with any ActiveMerchant functionality!
  # BusinessController
  match 'paypal/update', :to => 'business#update_paypal_profile', :constraints => { :protocol => "https" }
  match "paypal/update(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match 'direct_deposit/update', :to => 'business#update_direct_deposit_profile', :constraints => { :protocol => "https" }
  match "direct_deposit/update(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match 'paper_check/update', :to => 'business#update_paper_check_profile', :constraints => { :protocol => "https" }
  match "paper_check/update(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match 'populate_paper_check_profile/:id', :to => 'business#populate_paper_check_profile', :constraints => { :protocol => "https" }
  match "populate_paper_check_profile(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match 'populate_paypal_profile/:id', :to => 'business#populate_paypal_profile', :constraints => { :protocol => "https" }
  match "populate_paypal_profile(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match 'populate_direct_deposit_profile/:id', :to => 'business#populate_direct_deposit_profile', :constraints => { :protocol => "https" }
  match "populate_direct_deposit_profile(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  

  
  # Event/Voucher Stuff...
  match '/checkout/:id', :to => 'vouchers#checkout', :constraints => { :protocol => "https" }
  match "checkout(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/buy/:id', :to => 'vouchers#buy', :constraints => { :protocol => "https" }
  match "buy(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/event/:id', :to => 'vouchers#business_event_modify', :constraints => { :protocol => "https" }
  match "event(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/voucher/update', :to => 'vouchers#update', :constraints => { :protocol => "https" }
  match "voucher/update(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
  match '/deal/:id', :to => 'vouchers#show'
  match '/deal/status/:id', :to => 'vouchers#deal_status', :constraints => { :protocol => "https" }
  match "deal/status(/*path)", :to => redirect { |_, request|
    "https://" + request.host_with_port + request.fullpath }
    
  else
    
    # DEV-ONLY NON-SSL ROUTES
    
    # User stuff...
     # UserController
     #TODO:  Clean up redundant routes (has huge implications for URLs scattered around views, controllers...)
     match '/home', :to => 'user#home'
     match '/account', :to => 'user#account'

     match '/signup', :to => 'user#signup'
     match '/login', :to => 'user#login'
     match '/users/login', :to => 'user#login'
     match '/users/new', :to => 'user#signup'
     match '/users/logout', :to => 'devise/sessions#destroy'
     match '/user', :to => 'user#home'
     match '/user/update', :to => 'user#update'
     match '/user/change_password', :to => 'user#change_password'

     #User Payment Stuff
     match '/create_payment_profile', :to => 'user#create_payment_profile'
     match '/user/set_default_payment', :to => 'user#set_default_payment'

     # Business stuff...
     # BusinessController
     match '/business/landing', :to => 'business#landing'
     match '/business/login', :to => 'business#login'
     match '/business', :to => 'business#account'
     match '/business/update', :to => 'business#update'
     match '/business/account', :to => 'business#account'
     match '/business/new', :to => 'business#signup'
     match '/business/signup', :to => 'business#signup'
     match '/business/logout', :to => 'devise/sessions#destroy'
     match '/business/set_default_payment', :to => 'business#set_default_payment'
     match '/business/change_password', :to => 'business#change_password'

     # Business Payment Profile stuff...
     # NOT to be confused with any ActiveMerchant functionality!
     # BusinessController
     match 'paypal/update', :to => 'business#update_paypal_profile'
     match 'direct_deposit/update', :to => 'business#update_direct_deposit_profile'
     match 'paper_check/update', :to => 'business#update_paper_check_profile'
     match 'populate_paper_check_profile/:id', :to => 'business#populate_paper_check_profile'
     match 'populate_paypal_profile/:id', :to => 'business#populate_paypal_profile'
     match 'populate_direct_deposit_profile/:id', :to => 'business#populate_direct_deposit_profile'

     # Event/Voucher Stuff...
     match '/checkout/:id', :to => 'vouchers#checkout'
     match '/buy/:id', :to => 'vouchers#buy'
     match '/event/:id', :to => 'vouchers#business_event_modify'
     match '/voucher/update', :to => 'vouchers#update'
     match '/deal/:id', :to => 'vouchers#show'
     match '/deal/status/:id', :to => 'vouchers#deal_status'
     
     #END DEV ONLY NON-SSL ROUTES
     
   end
   
  match '/thumbs_up', :to => 'vouchers#thumbs_up'
  match '/thumbs_down', :to => 'vouchers#thumbs_down'
  match '/swap_featured', :to => 'vouchers#swap_featured'
  match '/swap_individual_deal', :to => 'vouchers#swap_individual_deal'
    
  # Static stuff...
  match '/contact', :to => 'pages#contact'
  match '/deal', :to => 'pages#deal'
  match '/dev', :to => 'pages#dev'
  match '/jobs', :to => 'pages#jobs'
  match '/about', :to => 'pages#about'
  match '/abuse', :to => 'pages#abuse'
  match '/press', :to => 'pages#press'
  match '/privacy', :to => 'pages#privacy'
  match '/terms', :to => 'pages#terms'
  
  match '/share_on_facebook/:id', :to => 'vouchers#share_on_facebook'
  match '/share_on_twitter/:id', :to => 'vouchers#share_on_twitter'
  
  match '/api/events_by_xml', :to => 'api#events_by_xml'
  match '/api/events_by_json', :to => 'api#events_by_json'
  match '/api/all_events', :to => 'api#all_events'
  match '/api/events', :to => 'api#events'
  
  match '/api/sencha/events', :to => 'api#sencha_events'
  match '/api/sencha/cities', :to => 'api#sencha_cities'
  match '/api/sencha/purchases', :to => 'api#sencha_purchases'
  match '/api/sencha/settings', :to => 'api#sencha_settings'
  match '/api/sencha/payments', :to => 'api#sencha_payments'
  
  match '/api/check_token', :to => 'api#check_token'
  match '/api/get_token', :to => 'api#get_token'
  
  match '/new-york-city', :to => 'user#home'
  match '/:city_name', :to => 'pages#coming_soon'
  

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
