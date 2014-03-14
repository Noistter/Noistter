class RssController < ApplicationController
  def index
    @tpuntuado = evaluar("hashtag", "mongo")
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end
  
  def rss
    @tipo=params[:tipo]
    @termino=params[:termino]
    @tpuntuacion = evaluar( @tipo, @termino ) 
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end
end
