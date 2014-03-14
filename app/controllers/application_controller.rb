require 'json'
class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
  
  def sendtweet
    text=params[:tuit]
    client.update(text) unless text == nil
    respond_to do |format|
        format.html {  }
	      format.json { head :no_content }
	      format.js
    end
  end
  
  def favorite
    tweet_id=params[:tuit_id]
    client.favorite(tweet_id)  unless tweet_id == nil
    respond_to do |format|
        format.html {  }
	      format.json { head :no_content }
	      format.js
    end
  end
  
  def retweet
    tweet_id=params[:tuit_id]
    client.retweet(tweet_id)  unless tweet_id == nil
    respond_to do |format|
        format.html {  }
	      format.json { head :no_content }
	      format.js
    end
  end
  
  private
  
  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = 'DogpapbYNWdAf9dOvAgpTQ'
      config.consumer_secret = 'lTXxr4qiGsaO78XeW0ZlA4dKWQka5tuz9crI4Xxm7w4'
      config.oauth_token = session['access_token']
      config.oauth_token_secret = session['access_token_secret']
    end
  end

  #CALCULAR RELEVANCIA
  def calculo(respuestas, retweets, favoritos, followers, rt)
    @puntuacion = (respuestas*3+retweets*2+favoritos) / Math.log(Math.sqrt(followers))
    if rt=="rt"
      @puntuacion=@puntuacion / 2
    end
    return @puntuacion
  end
  
  #METODO DE BUSQUEDA Y EVALUACION
  def evaluar(tipo, termino)
    case tipo
      when "tl"
        @timeline = client.home_timeline(:include_entities=>true, :count => 2000)
      when "perfil"
        @timeline = client.search("from:"+termino, :include_entities=>true, :count => 2000)
      when "hashtag"
          if termino[0]!='#'
            termino="#"+termino
          end
        @timeline = client.search(termino,:include_entities=>true, :count => 2000)
      else # when "termino"
        @timeline = client.search(termino,:include_entities=>true, :count => 2000)
    end
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
            #####FORMULA DE CALCULO DIRECTA ((@respuestas*3)+(tweet.retweet_count*2)+tweet.favorites_count)/ Math.log(Math.sqrt(tweet.user.followers_count))
            @tpuntuacion[@i]=ApplicationHelper::Tpuntuado.new(tweet.id, calculo(@respuestas, tweet.retweet_count, tweet.favorites_count, tweet.user.followers_count, ""), tweet.user.username, auto_link(tweet.text.dup.force_encoding("UTF-8"), target: '_blank') ,tweet.urls[0]['url'], tweet.user.profile_image_url, tweet.favorite_count, tweet.retweet_count, @respuestas, "")
            else
            #####FORMULA DE CALCULO DIRECTA ((@respuestas*3)+(tweet.retweet_count*2)+tweet.favorites_count)/ 2*Math.log(Math.sqrt(tweet.retweeted_status.user.followers_count))
            @tpuntuacion[@i]=ApplicationHelper::Tpuntuado.new(tweet.retweeted_status.id, calculo(@respuestas, tweet.retweet_count, tweet.favorites_count, tweet.retweeted_status.user.followers_count, "rt"), tweet.retweeted_status.user.username, auto_link(tweet.retweeted_status.text.dup.force_encoding("UTF-8"), target: '_blank') ,tweet.retweeted_status.urls[0]['url'], tweet.retweeted_status.user.profile_image_url, tweet.retweeted_status.favorite_count, tweet.retweeted_status.retweet_count, @respuestas, tweet.user.username)
          end
          @i=@i+1
          @respuestas=0
        end
    end
    @tpuntuacion.sort!{|e, f| -e.puntuacion <=> -f.puntuacion}
    #@timeline=@tpuntuacion
    @tpuntuacion=@tpuntuacion.first(54)
    @taux=[]
    return @tpuntuacion
  end  
end
