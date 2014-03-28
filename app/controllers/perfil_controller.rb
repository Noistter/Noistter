class PerfilController < ApplicationController
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
      @usuariobd = coll.find({usuario: @usuario}).to_a
      #de cada usuario (solo 1) sacamos su rss
      @usuariobd.each do |usuario|
      @rss = usuario["rss"]
      @busquedas = usuario["busquedas_guardadas"]
      end
      
      else
      redirect_to landpage_path
    end
  end
end
