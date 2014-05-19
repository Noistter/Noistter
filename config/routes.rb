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
  get '/rss/guarda_rss/:tipo/:termino' , to: 'rss#guardar_rss' , as: 'ajax'
  get '/rss/borrar_rss/:tipo/:termino' , to: 'rss#borrar_rss' , as: 'ajax'
  get '/rss/all_rss' , to: 'rss#all_rss' , as: 'ajax'
    
  #Refrescar TL
  get '/timeline/update' , to: 'timeline#update' , as: 'update'
  #Publicar Tuit desde Timeline
  get '/timeline/sendtweet' , to: 'timeline#sendtweet' , as: 'sendtweet'
  #Fav
  get '/favorite' , to: 'application#favorite' , as: 'favorite'
  get '/unfavorite' , to: 'application#unfavorite' , as: 'unfavorite'
  #Rt
  get '/retweet' , to: 'application#retweet' , as: 'retweet'
  get '/unretweet' , to: 'application#unretweet' , as: 'unretweet'
  #Save
  get '/save' , to: 'application#save' , as: 'save'
  get '/unsave' , to: 'application#save' , as: 'save'
  
  #Buscador
  #post 'buscador' , to: 'buscador#index' , as: 'buscador'
  get '/buscar' , to: 'buscador#index' , as: 'buscador' 
  get '/buscar/:opcion/:busqueda' , to: 'buscador#busqueda' , as: 'buscador'
  get '/buscar/:opcion' , to: 'buscador#busqueda' , as: 'buscador'  
  get '/buscar_ajax/:opcion/:busqueda' , to: 'buscador#busqueda_ajax' , as: 'ajax'
  get '/buscar/guardar_busq/:tipo/:termino' , to: 'buscador#guardar_busq' , as: 'ajax'
  get '/borrar_busqueda/:tipo/:termino' , to: 'buscador#borrar_busq' , as: 'ajax'

  #Privacidad
  get '/privacidad', to: 'privacidad#index', as: 'privacidad'
  
  #Perfil
  get '/perfil', to: 'perfil#index', as: 'perfil'
  
  #Evento
  get '/evento', to: 'evento#index', as: 'evento'
  get '/evento/live' , to: 'evento#live' , as: 'ajax'
  get '/evento/update' , to: 'evento#update' , as: 'ajax' 
  
  #Widget
  get '/widget', to: 'widget#form', as: 'widget'
  get '/widget/update' , to: 'widget#update' , as: 'ajax'
  get '/widget/:hashtag' , to: 'widget#index' , as: 'ajax' 
  
  
  #Herramientas
  get '/herramientas', to: 'herramientas#index', as: 'herramientas'
  
  
  if Rails.env.production?
   get '404', :to => 'application#page_not_found'
   get '422', :to => 'application#server_error'
   get '500', :to => 'application#server_error'
end
end