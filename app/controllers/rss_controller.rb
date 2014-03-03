class RssController < ApplicationController::Base
  def index
    
    #@posts = Post.all(:select => "title, author, id, content, posted_at", :order => "posted_at DESC", :limit => 5)
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
