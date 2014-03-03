require 'Tpuntuado'
class TimelineController < ApplicationController
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
    #Recogemos el TL y filtramos los links con enlaces
    @timeline = client.home_timeline(:include_entities=>true, :count => 200)
    ###################PRUEBAS PARA COGER TUISES MÁS ANTIGUOS #############################
    tamarray=@timeline.length
    ultima_id=@timeline[tamarray-1].id
    ultima_fecha=@timeline[tamarray-1].created_at
    hora=Time.now
    @diferencia=hora-ultima_fecha
    if(@diferencia < 7200)
      @timeline = @timeline + client.home_timeline(:include_entities=>true, :max_id =>ultima_id, :count => 200)
    end
    #####AHORA TOCA HACER EL BUCLE Y COMPROBAR LA DIFERENCIA, AMIGOS
    ###################FIN DE LAS PRUEBAS DE TUISES ANTIGUOS  #############################
    @taux = @timeline.find_all{|tweet| tweet.urls != []}
    #Creamos el array para almacenar los tuits ya puntuados
    @tpuntuacion = Array.new
    #Variables para contar el tuit en el que nos encontramos y las respuestas acumuladas
    @respuestas=0
    @i=0
    ##COMIENZO PUNTUACION
    #Para cada tuit con enlace
    for tweet in @taux
      ##COMIENZO CONTADOR RESPUESTAS
      #Para todos los tuits del timeline 
      for tweet2 in @timeline
        #Si es una respuesta al tuit que estamos evaluando, la añadimos
        if tweet2.in_reply_to_status_id==tweet.id
          @respuestas=@respuestas+1
        end
      end
      ##FIN CONTADOR RESPUESTAS
        #Si ha conseguido alguna interacción lo incluimos
        if tweet.retweet_count!=0 || tweet.favorites_count!=0 || @respuestas!=0
          #Si no es un tuit retuiteado, metemos la información original en el array
          if tweet.retweeted_status.nil?
            @tpuntuacion[@i]=TimelineHelper::Tpuntuado.new(tweet.id, ((@respuestas*3)+(tweet.retweet_count*2)+tweet.favorites_count)*100/ Math.sqrt(tweet.user.followers_count), tweet.user.username, tweet.text ,tweet.urls[0]['url'], tweet.user.profile_image_url, tweet.favorite_count, @diferencia, @respuestas, "")
          #Si es un tuit retuiteado, metemos la información del tuit del que proviene
          else
            @tpuntuacion[@i]=TimelineHelper::Tpuntuado.new(tweet.retweeted_status.id, (((@respuestas*3)+(tweet.retweet_count*2)+tweet.favorites_count)*100/ Math.sqrt(tweet.retweeted_status.user.followers_count)) * 0.75 , tweet.retweeted_status.user.username, tweet.retweeted_status.text ,tweet.retweeted_status.urls[0]['url'], tweet.retweeted_status.user.profile_image_url, tweet.favorite_count, tweet.retweet_count, @respuestas, tweet.user.username)
          end
          #Aumentamos el contador y reiniciamos el de respuestas
          @i=@i+1
          @respuestas=0
        end
    end
    ##FIN PUNTUACION
    #Ordenamos por puntuacion, devolvemos al array original y liberamos memoria
    @tpuntuacion.sort!{|e, f| -e.instance_variable_get(:@puntuacion) <=> -f.instance_variable_get(:@puntuacion)}
    @timeline=@tpuntuacion
    @taux=[]
    @tpuntuacion=[]
  end
  
  def index
    recogerTweets
  end
  
  def update
    recogerTweets
  end
  
  # POST /timeline/sendtweet
  # POST /timeline/sendtweet.json
  def sendtweet
    text=params[:tuit]
    client.update(text) unless text == nil
    respond_to do |format|
        format.html {  }
	      format.json { head :no_content }
	      format.js
    end
  end
  
  # POST /timeline/favorite
  # POST /timeline/favorite.jso
  def favorite
    tweet_id=params[:tuit_id]
    client.favorite(tweet_id)  unless tweet_id == nil
    respond_to do |format|
        format.html {  }
	      format.json { head :no_content }
	      format.js
    end
  end
end