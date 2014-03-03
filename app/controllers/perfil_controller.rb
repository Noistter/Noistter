class PerfilController < ApplicationController::Base
  def index
    #@img_usuario = client.user.profile_image_url
    @img_usuario = client.user.profile_image_url(:original) #normal, bigger, mini, original
    @usuario = client.user.username
  end
end
