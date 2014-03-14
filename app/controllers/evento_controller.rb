class EventoController < ApplicationController
  layout :resolve_layout
  
  class TweetLive
    def initialize (id, texto, username, perfilimg)
        @id=id
        @text=texto
        @username=username
        @perfilimg=perfilimg
      end
  end

	def resolve_layout
	   case action_name
     when "index"
        "evento"
	   else
	      "ajax"
     end
  end
  
  def index
    
  end
  
  def live
    @id_video = params[:idvideo]
    @id_video = @id_video.partition(/.=/)
    @id_video = @id_video[2]
    
    @hashtag=params[:hashtag]
     if @hashtag[0]!='#'
       @hashtag_name="#"+@hashtag
     else
        @hashtag_name=@hashtag       
     end 
    
    @tpuntuacion = evaluar('hashtag', @hashtag )
  end
end
