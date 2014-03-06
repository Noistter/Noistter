class PerfilController < ApplicationController
  def index
    #@img_usuario = client.user.profile_image_url
    @img_usuario = client.user.profile_image_url(:original) #normal, bigger, mini, original
    @usuario = client.user.username
    @tuits = client.user.tweets_count
    @followers = client.user.followers_count
    @following = client.user.friends_count
    @location = client.user.location
    @favoritos = client.user.favorites_count
    @listas = client.user.listed_count
    @creado = client.user.created_at
    @idioma = client.user.lang
    @descripcion = client.user.description
  end
end
