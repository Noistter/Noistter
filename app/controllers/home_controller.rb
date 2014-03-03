require 'Tpuntuado'

class HomeController < ApplicationController
    layout :resolve_layout

	  def resolve_layout
	    case action_name
      when "index"
        "timeline"
	    else
	      "ajax"
      end
    end
  
  def recogerTweets
    @timeline = client.home_timeline(:include_entities=>true, :count => 2000)
    @taux = @timeline.find_all{|tweet| tweet.urls != []}
    @tpuntuacion = Array.new
    @respuestas=0
    @i=0
    for tweet in @taux      
        for tweet2 in @timeline
          id=tweet.id
          if tweet2.in_reply_to_status_id==id
            @respuestas=@respuestas+1
          end
        end
        if tweet.retweet_count!=0 || tweet.favorites_count!=0 || @respuestas!=0
          if tweet.retweeted_status.nil?
            @tpuntuacion[@i]=TimelineHelper::Tpuntuado.new(tweet.id, ((@respuestas*3)+(tweet.retweet_count*2)+tweet.favorites_count)*100/ Math.sqrt(tweet.user.followers_count), tweet.user.username, tweet.text ,tweet.urls[0]['url'], tweet.user.profile_image_url, tweet.favorite_count, tweet.retweet_count, @respuestas, "")
            else
            @tpuntuacion[@i]=TimelineHelper::Tpuntuado.new(tweet.retweeted_status.id, ((@respuestas*3)+(tweet.retweet_count*2)+tweet.favorites_count)*100/ Math.sqrt(tweet.retweeted_status.user.followers_count), tweet.retweeted_status.user.username, tweet.retweeted_status.text ,tweet.retweeted_status.urls[0]['url'], tweet.retweeted_status.user.profile_image_url, tweet.favorite_count, tweet.retweet_count, @respuestas, tweet.user.username)
          end
          @i=@i+1
          @respuestas=0
        end
    end
    @tpuntuacion.sort!{|e, f| -e.instance_variable_get(:@puntuacion) <=> -f.instance_variable_get(:@puntuacion)}
    @timeline=@tpuntuacion
    @taux=[]
  end
  
  def index
    recogerTweets
  end
  
  def update
    recogerTweets
  end
end