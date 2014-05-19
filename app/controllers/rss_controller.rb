class RssController < ApplicationController
   layout :resolve_layout

	  def resolve_layout
	    case action_name
      when "index"
        "application"
      when "rss"
        "application"
	    else
	      "ajax"
      end
    end
  
  
  def index
    if session['access_token'] && session['access_token_secret']
      
      @usuario = client.user.username
      
      db = get_connection
      coll = db.collection('usuarios')
      usuariobd = coll.find({usuario: @usuario}).to_a
      #de cada usuario (solo 1) sacamos su rss
      usuariobd.each do |usuario|
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
  
  def all_rss
      if session['access_token'] && session['access_token_secret']
        @usuario = client.user.username
      
      db = get_connection
      coll = db.collection('usuarios')
      usuariobd = coll.find({usuario: @usuario}).to_a
      #de cada usuario (solo 1) sacamos su rss
      usuariobd.each do |usuario|
        @rss = usuario["rss"] 
      end      
      else
      redirect_to landpage_path
    end
    respond_to do |format|
        format.html {  }
	      format.json { head :no_content }
	      format.js
    end
  end
  
  def guardar_rss
    tipo=params[:tipo] #tipo de busqueda
    termino=params[:termino] #termino de la busqueda    
    db = get_connection
    coll = db.collection('usuarios')    
    #usuario="alexsanchez8" #¿Como saco el usuario desde aqui sin hacer el client.username?
    usuario=client.user.username
    if (tipo=="usuario" || tipo=="hashtag" || tipo=="termino") && termino!=""
      record = coll.find({usuario: usuario, rss:{tipo: tipo, termino: termino}}).to_a
      if record==[]  # <----  Si, eso es como un NULL 
        coll.update({usuario: usuario}, {"$push" => {rss: {tipo: tipo, termino: termino}}})
      end    
    end
    respond_to do |format|
        format.html {  }
	      format.json { head :no_content }
	      format.js
    end
  end
  
  def borrar_rss 
    tipo=params[:tipo] #tipo de busqueda
    termino=params[:termino] #termino de la busqueda
    usuario=client.user.username
    db = get_connection
    coll = db.collection('usuarios')    
    if (tipo=="usuario" || tipo=="hashtag" || tipo=="termino") && termino!=""
      record = coll.find({usuario: usuario, rss:{tipo: tipo, termino: termino}}).to_a
      if record!=[]  # <----  Si, eso es como un NULL 
        coll.update({usuario: usuario}, {"$pull" => {rss: {tipo: tipo, termino: termino}}})
      end    
    end
  end
end
