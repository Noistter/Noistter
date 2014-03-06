// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


$( document ).ready(function() {
    $( "#bt_send_tweet" ).click(function() {
	  $.ajax({type: 'get', 
	  	url: "timeline/sendtweet", 
      data: { tuit:  $(".texttweet" ).val() },
	  	success: function (response) {
                    $( "#btn_update" ).trigger('click');
                    $(".texttweet").val("");
                    $( ".confirm_tweet" ).append(response);

                }, 
	  	error: function() { $( ".confirm_tweet" ).append('Error al enviar!'); }
	   });
	  return(false); 
	});
  
  
    $( "#btn_update" ).click(function() {
	  $.ajax({type: 'get', 
	  	url: "timeline/update", 
	  	success: function (response) {
                   $( ".timeline_container" ).html(response);
                }, 
	  	error: function() { $( ".timeline_container" ).append('Rate Limit!'); }
	   });
	  return(false); 
	  });
  
    $( ".fav" ).click(function() {
      //alert($(this).attr('id'));
	  $.ajax({type: 'get', 
	  	url: "favorite",
      data: { tuit_id:  $(this).attr('id') },  
	  	success: function (response) {  $( ".confirm_tweet" ).append(response); }, 
	  	error: function(response) { $( ".confirm_tweet" ).append(response); }
	   });
	  return(false); 
	});
  
    $( ".rt" ).click(function() {
      //alert($(this).attr('id'));
	  $.ajax({type: 'get', 
	  	url: "retweet",
      data: { tuit_id:  $(this).attr('id') },  
	  	success: function (response) {  $( ".confirm_tweet" ).append(response); }, 
	  	error: function(response) { $( ".confirm_tweet" ).append(response); }
	   });
	  return(false); 
	});
  
  $( ".gatillo" ).click(function() { 
    if($(this).hasClass('desplegado')){
      $(this).removeClass('desplegado');
      $('.buscador').removeClass('desplegado');
    }
    else{
      $(this).addClass('desplegado');
      $('.buscador').addClass('desplegado');
    }
      
  });
  
  $( "li.opcion" ).click(function() { 
      $("li.opcion").removeClass('seleccionada');
      $(this).addClass('seleccionada');      
  });
  
  $( ".gatillo_menu" ).click(function() { 
    if($('nav').hasClass('desplegado')){
      $('nav').removeClass('desplegado');
    } 
    else {
       $('nav').addClass('desplegado');      
    }
  });
  
  $( ".close_menu" ).click(function() { 
       $('nav').removeClass('desplegado');      
  });
  
  $( ".trigger_tweet" ).click(function() { 
       $('.overlay_tuitear').addClass('desplegado');
       $('.texttweet').focus();
       $('.texttweet').attr("maxlength", 140);
  });
  
  $( ".overlay_tuitear, .close_tuitear" ).click(function() { 
       $('.overlay_tuitear').removeClass('desplegado');      
  });
  
  $( ".overlay_contenedor" ).click(function(event) { 
       event.stopPropagation();     
  });
  
  
  $( "#bt_ver_evento" ).click(function() { 
	  $.ajax({type: 'get', 
	  	url: "evento/live", 
      data: { idvideo:  $("#id_video").val(), hashtag:  $("#ht_evento").val() },
	  	success: function (response) {
          $( ".evento_container" ).html(response);
      }, 
	  	error: function() { $( ".evento_container" ).append('Error al enviar!'); }
	   });
	  return(false); 
	}); 
  
});

function contarCaracteres(){
  $(".caracteres").html(140-$(".texttweet").val().length)
}

function onloader(){
  alert("HOLAAAA");    
}