require 'Tpuntuado'

class BuscadorController < ApplicationController
  
  def index
    @busqueda=params[:busqueda]
    @opcion=params[:opcion]    
    @queBusca=@busqueda
    
    @busqueda=@busqueda+" filter:links"
    
    @tpuntuacion = evaluar('hashtag', @hashtag )
    
    case params[:opcion]
      when "tl"
        @busqueda=@busqueda
      when "usuario"        
        if @busqueda[0]=='@'
          @busqueda="from:"+@busqueda
          @queBusca="Tweets de "+@queBusca
        else
          @busqueda="from:@"+@busqueda
          @queBusca="Tweets de @"+@queBusca          
        end
      when "hashtag"
        if @busqueda[0]!='#'
          @busqueda="#"+@busqueda
          @queBusca="#"+@queBusca
        end
      else
        @busqueda=@busqueda
      end    
    
    @result = client.search(@busqueda, :count => 2000, :result_type => "recent").collect
    #@timeline = client.home_timeline(:include_entities=>true, :count => 2000)
    @taux = @result.find_all{|tweet| tweet.urls != []}
    @tpuntuacion = Array.new
    @respuestas=0
    @i=0
    for tweet in @taux      
        for tweet2 in @result
          id=tweet.id
          if tweet2.in_reply_to_status_id==id
            @respuestas=@respuestas+1
          end
        end
        if tweet.retweet_count!=0 || tweet.favorites_count!=0 || @respuestas!=0
          if tweet.retweeted_status.nil?
            @tpuntuacion[@i]=ApplicationHelper::Tpuntuado.new(tweet.id, ((@respuestas*3)+(tweet.retweet_count*2)+tweet.favorites_count)*100/ Math.sqrt(tweet.user.followers_count), tweet.user.username, tweet.text ,tweet.urls[0]['url'], tweet.user.profile_image_url, tweet.favorite_count, tweet.retweet_count, @respuestas, "")
            else
            @tpuntuacion[@i]=ApplicationHelper::Tpuntuado.new(tweet.retweeted_status.id, ((@respuestas*3)+(tweet.retweet_count*2)+tweet.favorites_count)*100/ Math.sqrt(tweet.retweeted_status.user.followers_count), tweet.retweeted_status.user.username, tweet.retweeted_status.text ,tweet.retweeted_status.urls[0]['url'], tweet.retweeted_status.user.profile_image_url, tweet.favorite_count, tweet.retweet_count, @respuestas, tweet.user.username)
          end
          @i=@i+1
          @respuestas=0
        end
    end
    @tpuntuacion.sort!{|e, f| -e.puntuacion <=> -f.puntuacion}
    @result=@tpuntuacion    
    @taux=[]
  end
  
  def busqueda
    #busqueda directa, mediante URL
    @tipo=params[:tipo] #tipo de busqueda
    @termino=params[:termino] #termino de la busqueda
    
    #Aqui llamaremos a un helper del tipo:
    #@resultado = busqueda_noistter( @tipo, @termino )
  end
end