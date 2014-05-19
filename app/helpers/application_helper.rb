require 'twitter-text'
module ApplicationHelper
  #CONVERTIR TEXTOS DE LINK EN ENLACES
  include Twitter::Autolink

  #CLASE TPUNTUADO, CON LOS TWEETS FORMATEADOS PARA MOSTRAR
  class Tpuntuado
      def initialize (id, puntuacion, username, text, link, perfilimg, favorite_count, retweet_count, respuestas, retweeted_by, retweeted, favorited)
        @id=id
        @puntuacion=puntuacion
        @username=username
        @text=text
        @link=link
        @perfilimg=perfilimg
        @favorite_count=favorite_count
        @retweet_count=retweet_count
        @respuestas=respuestas
        @retweeted_by=retweeted_by
        @retweeted=retweeted
        @favorited=favorited
      end
      def id
        @id
      end
      def puntuacion
        @puntuacion
      end
      def username
        @username
      end
      def text
        @text
      end
      def link
        @link
      end
      def perfilimg
        @perfilimg
      end
      def favorite_count
        @favorite_count
      end
      def retweet_count
        @retweet_count
      end
      def respuestas
        @respuestas
      end
      def retweeted_by
        @retweeted_by
      end
      def retweeted
        @retweeted
      end
      def favorited
        @favorited
      end
  end
end
