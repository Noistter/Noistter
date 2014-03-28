Noister::Application.routes.draw do
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
  get '/buscar/:opcion/:busqueda' , to: 'buscador#busqueda' , as: 'buscador'
  get '/buscar/:opcion' , to: 'buscador#busqueda' , as: 'buscador' 
  
  get '/buscar_ajax/:opcion/:busqueda' , to: 'buscador#busqueda_ajax' , as: 'ajax'
  
  #Privacidad
  get '/privacidad', to: 'privacidad#index', as: 'privacidad'
  
  #Perfil
  get '/perfil', to: 'perfil#index', as: 'perfil'
  
  #Evento
  get '/evento', to: 'evento#index', as: 'evento'
  get '/evento/live' , to: 'evento#live' , as: 'ajax' 
  
  #Widget
  get '/widget', to: 'widget#form', as: 'widget'
  get '/widget/:hashtag' , to: 'widget#index' , as: 'ajax' 
  
  #Herramientas
  get '/herramientas', to: 'herramientas#index', as: 'herramientas'
end