class PerfilController < ApplicationController
  
  layout :resolve_layout

	  def resolve_layout
	    case action_name
      when "index"
        "application"
	    else
	      "ajax"
      end
    end
  
  
  def index
    if session['access_token'] && session['access_token_secret']    
        
      @peticion = client.user
      @img_usuario = @peticion.profile_image_url(:original) #normal, bigger, mini, original
      @usuario = @peticion.username
      @descripcion = @peticion.description
      @tuits =  @peticion.tweets_count
      @followers = @peticion.followers_count
      @following =  @peticion.friends_count
      #@location = client.user.location
      #@favoritos = client.user.favorites_count
      #@listas = client.user.listed_count
      #@creado = client.user.created_at
      #@idioma = client.user.lang
            
      db = get_connection
      coll = db.collection('usuarios')
      
      #Si el usuario no existe en la bd creamos uno nuevo
      record = coll.find({usuario: @usuario}).to_a      
      if record==[]  # <----  Si, eso es como un NULL 
        coll.insert({usuario:  @usuario, rss: [], busquedas_guardadas: [], tweets_guardados: []})
      end
      
      usuariobd = coll.find({usuario: @usuario}).to_a
      #de cada usuario (solo 1) sacamos su rss
      usuariobd.each do |usuario|
        @rss = usuario["rss"]
        @busquedas = usuario["busquedas_guardadas"]
        
      end
      @favoritos = client.favorites
      @tfavoritos = Array.new
      @i=0
      puts @favoritos
      @favoritos.each do |tweet|
          if tweet.retweeted_status.nil?
            @tfavoritos[@i]=ApplicationHelper::Tpuntuado.new(tweet.id, 0, tweet.user.username, auto_link(tweet.text.dup.force_encoding("UTF-8"), target: '_blank') , "", tweet.user.profile_image_url, tweet.favorite_count, tweet.retweet_count, 0, "", tweet.retweeted, tweet.favorited)
            else
            @tfavoritos[@i]=ApplicationHelper::Tpuntuado.new(tweet.retweeted_status.id, 0, tweet.retweeted_status.user.username, auto_link(tweet.retweeted_status.text.dup.force_encoding("UTF-8"), target: '_blank') , "", tweet.retweeted_status.user.profile_image_url, tweet.retweeted_status.favorite_count, tweet.retweeted_status.retweet_count, 0, tweet.user.username, tweet.retweeted, tweet.favorited)
          end        
          @i=@i+1
      end
      else
      redirect_to landpage_path
    end
  end
end
