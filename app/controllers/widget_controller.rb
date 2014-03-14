class WidgetController < ApplicationController
  layout 'ajax'
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
         
    @tpuntuacion = evaluar('hashtag', @hashtag )
  end
  
end
