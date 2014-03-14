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
   
    
    @timeline = client.search(@hashtag, :count => 2000, :result_type => "recent").collect
    
    @result=Array.new
    @result = evaluar('hashtag', @hashtag )
    #@i=0
    
    #for tweet in @timeline
     # @result[@i]=TweetLive.new(tweet.id, tweet.text, tweet.user.username ,  tweet.user.profile_image_url)
      #@i=@i+1      
    #end
    
  end
end
