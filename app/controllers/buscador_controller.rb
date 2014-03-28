require 'Tpuntuado'

class BuscadorController < ApplicationController
    layout :resolve_layout

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
      
      if @tipo == "timeline"
        redirect_to :controller=>'home', :action => 'index'
      else
        @resultado = evaluar( @tipo, @termino )      
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
  
  def busqueda_ajax
    busqueda
  end
  
  def guardar_busq
    @guard_tipo=params[:opcion] #tipo de busqueda
    @guard_busqueda=params[:busqueda] #termino de la busqueda
    
    db = get_connection
    coll = db.collection('usuarios')
    #coll.insert()
  end
end