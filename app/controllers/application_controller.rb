require 'json'
class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
  
  layout "ajax"
  
  def get_connection
    return @db_connection if @db_connection
    db = URI.parse('mongodb://noistter:noistter@oceanic.mongohq.com:10016/noistter_db')
    db_name = db.path.gsub(/^\//, '')
    @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
    @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
    @db_connection
  end
  
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
  
  def unfavorite
    tweet_id=params[:tuit_id]
    client.unfavorite(tweet_id)  unless tweet_id == nil
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
  
  def unretweet
    tweet_id=params[:tuit_id]
    #client.destroy(tweet_id)  unless tweet_id == nil     #¿COMO SE UNRETWITEARA?
    @usuario = client.user.username
    @retuits = client.search("from:"+@usuario , :include_entities=>true, :count => 2000)
    for tweet in @retuits
      if tweet.retweeted_status.nil?
      else
        if tweet.retweeted_status.id.to_s == tweet_id.to_s
          client.destroy_status(tweet.id)
        end
      end
    end
    
    respond_to do |format|
        format.html {  }
	      format.json { head :no_content }
	      format.js
    end
  end
  
  private
  
  def client
    puts "*** Llamada a client ***"
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = 'DogpapbYNWdAf9dOvAgpTQ'
      config.consumer_secret = 'lTXxr4qiGsaO78XeW0ZlA4dKWQka5tuz9crI4Xxm7w4'
      config.oauth_token = session['access_token']
      config.oauth_token_secret = session['access_token_secret']
    end
  end

  #CALCULAR RELEVANCIA
  def calculo(respuestas, retweets, favoritos, followers, rt)
    @puntuacion = (respuestas*5+retweets*3+favoritos) / Math.log(Math.sqrt(followers))
    if rt=="rt"
      @puntuacion=@puntuacion / 2
    end
    return @puntuacion
  end
  
  
  
  
  #METODO DE BUSQUEDA Y EVALUACION
  def evaluar(tipo, termino)
    case tipo
      when "timeline"
        @timeline = client.home_timeline(:include_entities=>true, :count => 2000)
      when "usuario"
        if termino[0]!='@'
          termino="@"+termino
        end
        @timeline = client.search("from:"+termino+" -rt", :include_entities=>true, :count => 2000)
      when "hashtag"
        if termino[0]!='#'
          termino="#"+termino
        end
        @timeline = client.search(termino+" -rt",:include_entities=>true, :count => 2000)
      else # when "termino"
        @timeline = client.search(termino+" -rt",:include_entities=>true, :count => 2000)
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
            @tpuntuacion[@i]=ApplicationHelper::Tpuntuado.new(tweet.id, calculo(@respuestas, tweet.retweet_count, tweet.favorites_count, tweet.user.followers_count, ""), tweet.user.username, auto_link(tweet.text.dup.force_encoding("UTF-8"), target: '_blank') ,tweet.urls[0]['url'], tweet.user.profile_image_url, tweet.favorite_count, tweet.retweet_count, @respuestas, "", tweet.retweeted, tweet.favorited)
            
            else
            #####FORMULA DE CALCULO DIRECTA ((@respuestas*3)+(tweet.retweet_count*2)+tweet.favorites_count)/ 2*Math.log(Math.sqrt(tweet.retweeted_status.user.followers_count))
            @tpuntuacion[@i]=ApplicationHelper::Tpuntuado.new(tweet.retweeted_status.id, calculo(@respuestas, tweet.retweet_count, tweet.favorites_count, tweet.retweeted_status.user.followers_count, "rt"), tweet.retweeted_status.user.username, auto_link(tweet.retweeted_status.text.dup.force_encoding("UTF-8"), target: '_blank') ,tweet.retweeted_status.urls[0]['url'], tweet.retweeted_status.user.profile_image_url, tweet.retweeted_status.favorite_count, tweet.retweeted_status.retweet_count, @respuestas, tweet.user.username, tweet.retweeted, tweet.favorited)
          end
          if tweet.retweeted
            puts "id =  #{tweet.id} rt #{tweet.retweeted}"
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
  
  
  
  #METODO DE BUSQUEDA Y EVALUACION
  def evaluar_evento(tipo, termino, id_since, notamedia, ids)
    @notamedia=notamedia
    @timeline = client.search(termino+" -rt",:include_entities =>true, :result_type =>"recent",  :since_id =>id_since,  :count => 2000 )
    @taux = @timeline
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
            @tpuntuacion[@i]=ApplicationHelper::Tpuntuado.new(tweet.id, calculo(@respuestas, tweet.retweet_count, tweet.favorites_count, tweet.user.followers_count, ""), tweet.user.username, auto_link(tweet.text.dup.force_encoding("UTF-8"), target: '_blank') ,"", tweet.user.profile_image_url, tweet.favorite_count, tweet.retweet_count, @respuestas, "", tweet.retweeted, tweet.favorited)
            #@notamedia[1]=@notamedia[1]+1
            #@notamedia[0]=(calculo(@respuestas, tweet.retweet_count, tweet.favorites_count, tweet.user.followers_count, "")) / @notamedia[1]
            else
            #####FORMULA DE CALCULO DIRECTA ((@respuestas*3)+(tweet.retweet_count*2)+tweet.favorites_count)/ 2*Math.log(Math.sqrt(tweet.retweeted_status.user.followers_count))
            @tpuntuacion[@i]=ApplicationHelper::Tpuntuado.new(tweet.retweeted_status.id, calculo(@respuestas, tweet.retweet_count, tweet.favorites_count, tweet.retweeted_status.user.followers_count, "rt"), tweet.retweeted_status.user.username, auto_link(tweet.retweeted_status.text.dup.force_encoding("UTF-8"), target: '_blank') ,"", tweet.retweeted_status.user.profile_image_url, tweet.retweeted_status.favorite_count, tweet.retweeted_status.retweet_count, @respuestas, tweet.user.username, tweet.retweeted, tweet.favorited)
            @notamedia[1]=@notamedia[1]+1
            @notamedia[0]=(calculo(@respuestas, tweet.retweet_count, tweet.favorites_count, tweet.user.followers_count, "")) / notamedia[0]
          end
          @i=@i+1
          @respuestas=0
        end
    end
    #@tpuntuacion.sort!{|e, f| -e.puntuacion <=> -f.puntuacion}
    #@timeline=@tpuntuacion
    @tpuntuacion=@tpuntuacion.first(54)
    @taux=[]
    
    return @tpuntuacion
  end
  
  
  def page_not_found
    respond_to do |format|
      format.html { render template: 'errors/not_found_error', layout: 'layouts/application', status: 404 }
      format.all  { render nothing: true, status: 404 }
    end
  end

  def server_error
    respond_to do |format|
      format.html { render template: 'errors/internal_server_error', layout: 'layouts/error', status: 500 }
      format.all  { render nothing: true, status: 500}
    end
  end
  
 
  
  
end
