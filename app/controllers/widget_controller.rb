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
    @hashtag = "#"+@hashtag
    
    @timeline = client.search(@hashtag, :count => 2000, :result_type => "recent").collect
    
    @result=Array.new
    @i=0
    
    for tweet in @timeline
      @result[@i]=TweetWidget.new(tweet.id, tweet.text, tweet.user.username ,  tweet.user.profile_image_url)
      @i=@i+1 
    end
  end
  
end
