class WidgetController < ApplicationController
  layout :resolve_layout

	  def resolve_layout
	    case action_name
      when "form"
        "widget"
	    else
	      "ajax"
      end
    end
  
  
  class TweetWidget
    def initialize (id, texto, username, perfilimg)
        @id=id
        @text=texto
        @username=username
        @perfilimg=perfilimg
      end
  end
  
  
  def index
    @hashtag = params[:hashtag]
    
    if @hashtag[0]!='#'
      @hashtag = "#"+@hashtag
    end
         
    @tpuntuacion = evaluar_evento('hashtag', @hashtag, 0,0,0 )
  end
  
  
  @@notamedia=[0,0]
  @ids=[]
  def update
    @hashtag=params[:hashtag]
     if @hashtag[0]!='#'
       @hashtag_name="#"+@hashtag
     else
        @hashtag_name=@hashtag       
     end     
    @id_since=params[:id_since]
    puts  "id since "
    puts  @id_since 
    
    @tpuntuacion = evaluar_evento('hashtag', @hashtag, @id_since, @@notamedia, @ids)
  end
  
end
