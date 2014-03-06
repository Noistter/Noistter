class RssController < ApplicationController
  def index
    @timeline = client.home_timeline(:include_entities=>true, :count => 200)
    @taux = @timeline.find_all{|tweet| tweet.urls != []}
    @rss  = Array.new
    @i=0
    for tweet in @taux
      url = tweet.urls[0]["expanded_url"]
      @rss[@i]=RssHelper::Trss.new(tweet.id,tweet.user.username, tweet.text , url )
       @i= @i+1
    end     
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end
end
