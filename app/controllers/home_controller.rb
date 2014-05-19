class HomeController < ApplicationController
    include Twitter::Autolink
    layout :resolve_layout

	  def resolve_layout
	    case action_name
      when "index"
        "timeline"
	    else
	      "ajax"
      end
    end
 
  
  
  def index
    @tpuntuacion=evaluar("timeline","")
  end
  
  def update
    @tpuntuacion=evaluar("timeline","")
  end
end