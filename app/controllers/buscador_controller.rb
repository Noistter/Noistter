require 'Tpuntuado'

class BuscadorController < ApplicationController
  layout :resolve_layout
  include ApplicationHelper

	  def resolve_layout
	    case action_name
      when "index"
        "application"
      when "busqueda"
        "application"
	    else
	      "ajax"
      end
    end
  
  def index    
  end
  
  def busqueda
      #busqueda directa, mediante URL
      @tipo=params[:opcion] #tipo de busqueda
      @termino=params[:busqueda] #termino de la busqueda
      
      @no_esta = false
      db = get_connection
      coll = db.collection('usuarios')
      #usuario="alexsanchez8" #¿Como saco el usuario desde aqui sin hacer el client.username?
      usuario=client.user.username
      record = coll.find({usuario: usuario, busquedas_guardadas:{tipo: @tipo, termino: @termino}}).to_a
      if record==[]  # <----  Si, eso es como un NULL 
        @no_esta = true
      end
    
    if @termino != ""
      if @tipo == "timeline"
        redirect_to :controller=>'home', :action => 'index'
      else
        @tpuntuacion = evaluar( @tipo, @termino )      
          case params[:opcion]
          when "usuario"
            @opcion = "TL de @"
          when "hashtag"
            @opcion = "#"
          else
            @opcion = ""
          end        
        @titulo = params[:busqueda]      
      end
    end
  end
  
  def busqueda_ajax
    busqueda
  end
  
  def guardar_busq
    tipo=params[:tipo] #tipo de busqueda
    termino=params[:termino] #termino de la busqueda    
    db = get_connection
    coll = db.collection('usuarios')    
    #usuario="alexsanchez8" #¿Como saco el usuario desde aqui sin hacer el client.username?
    usuario=client.user.username
    if (tipo=="usuario" || tipo=="hashtag" || tipo=="termino") && termino!=""
      record = coll.find({usuario: usuario, busquedas_guardadas:{tipo: tipo, termino: termino}}).to_a
      if record==[]  # <----  Si, eso es como un NULL 
        coll.update({usuario: usuario}, {"$push" => {busquedas_guardadas: {tipo: tipo, termino: termino}}})
      end    
    end
    respond_to do |format|
        format.html {  }
	      format.json { head :no_content }
	      format.js
    end
    redirect_to :back
  end
  
  def borrar_busq
    tipo=params[:tipo] #tipo de busqueda
    termino=params[:termino] #termino de la busqueda    
    db = get_connection
    coll = db.collection('usuarios')
    usuario=client.user.username
    if (tipo=="usuario" || tipo=="hashtag" || tipo=="termino") && termino!=""
      record = coll.find({usuario: usuario, busquedas_guardadas:{tipo: tipo, termino: termino}}).to_a
      if record!=[]  # <----  Si, eso es como un NULL 
        coll.update({usuario: usuario}, {"$pull" => {busquedas_guardadas: {tipo: tipo, termino: termino}}})
      end    
    end
    respond_to do |format|
        format.html {  }
	      format.json { head :no_content }
	      format.js
    end
  end
end