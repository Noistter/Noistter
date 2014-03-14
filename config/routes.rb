Noister::Application.routes.draw do

  get "rss/index"

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
  root :to => 'sessions#show' #'landpage#index'
      
  #Login Twitter
  get '/auth/twitter/callback', to: 'sessions#create', as: 'callback'
  get '/auth/failure', to: 'sessions#error', as: 'failure'
  get '/logout', to: 'sessions#destroy', as: 'logout'  
  
  get '/timeline', to: 'timeline#index', as: 'timeline'
  get '/landpage', to: 'landpage#index', as: 'landpage'
  get '/home', to: 'home#index', as: 'home'
  get '/rss', to: 'rss#index', as: 'rss'
  get '/rss/:tipo/:termino/atom' , to: 'rss#rss' , as: 'rss'  
  
  
  #Refrescar TL
  get '/timeline/update' , to: 'timeline#update' , as: 'update'
  #Publicar Tuit desde Timeline
  get '/timeline/sendtweet' , to: 'timeline#sendtweet' , as: 'sendtweet'
  #Fav
  get 'favorite' , to: 'application#favorite' , as: 'favorite'
  #Rt
  get 'retweet' , to: 'application#retweet' , as: 'retweet'
  
  #Buscador
  #post 'buscador' , to: 'buscador#index' , as: 'buscador'
  get '/buscar' , to: 'buscador#index' , as: 'buscador' 
  get '/buscar/:tipo/:termino' , to: 'buscador#busqueda' , as: 'buscador'  
  
  #Privacidad
  get '/privacidad', to: 'privacidad#index', as: 'privacidad'
  
  #Perfil
  get '/perfil', to: 'perfil#index', as: 'perfil'
  
  #Evento
  get '/evento', to: 'evento#index', as: 'evento'
  get '/evento/live' , to: 'evento#live' , as: 'ajax' 
  
  get '/widget/:hashtag' , to: 'widget#index' , as: 'ajax' 

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end