class RssController < ApplicationController
  def index
        
    if session['access_token'] && session['access_token_secret']
      @peticion = client.user
      @usuario = @peticion.username
      
      db = get_connection
      coll = db.collection('usuarios')
      @usuariobd = coll.find({usuario: @usuario}).to_a
      #de cada usuario (solo 1) sacamos su rss
      @usuariobd.each do |usuario|
        @rss = usuario["rss"] 
      end
      
      else
      redirect_to landpage_path
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
