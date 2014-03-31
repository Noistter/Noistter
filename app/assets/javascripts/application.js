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
                    $(".caracteres").html(140)
                    $(".caracteres").css({ color: "#777"});
                    $( "#btn_update" ).trigger('click');
                    $(".texttweet").val("");
                    $(".confirm_tweet").css({ color: "#00ff00"});
                    $( ".confirm_tweet" ).html(response);
                }, 
	  	error: function() {
        $(".confirm_tweet").css({ color: "#ff0000"});
        if($(".texttweet").val().length == 0)
          $(".confirm_tweet").html('¡Venga va! Anímate y escribe algo.');
        else
          $(".confirm_tweet").html('Has superado los 140 caracteres. Acórtalo un poquito.');
      }
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
  
  
  $( "#previa_rss" ).click(function() { 
	  $.ajax({type: 'get', 
            url: "buscar_ajax/"+$('#rss_tipo').val()+"/"+$('#rss_termino').val(),
	  	success: function (response) {
                   $( "#vista_previa" ).html(response);
                   $( "#vista_previa").slideDown();
                   $( "#btn_guardar_rss").show(); 
                   
                }, 
	  	error: function() { $( "#vista_previa" ).append('Rate Limit!'); }
	   });
	  return(false); 
	  });
  
  $( ".gatillo" ).click(function() { 
    if($(this).hasClass('desplegado')){
      $(this).removeClass('desplegado');
      $('.buscador').removeClass('desplegado');
      $('#error').html("") 
    }
    else{
      $(this).addClass('desplegado');
      $('.buscador').addClass('desplegado');
    }
      
  });
  
  $( "li.opcion" ).click(function() { 
      $("li.opcion").removeClass('seleccionada');
      $(this).addClass('seleccionada');
      
      if($('#op_tl').hasClass( 'seleccionada' ))
      {
        //$('#termino').addClass('twcard oculto');
        //$('#termino').removeClass('invisible);
        $('#termino').css('visibility', 'hidden');
        $('#termino').val("");
        $('#termino').attr('disabled', true);
        $('#error').html("") 
      }
      else
      { 
        //$('#termino').removeClass('twcard oculto');
        //$('#termino').addClass('invisible);
        $('#termino').css('visibility', 'visible');
        $("#termino").attr('disabled', false);
      }
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
       contarCaracteres()
       $('.texttweet').focus();
  });
  
  $( ".overlay_tuitear, .close_tuitear" ).click(function() {
       $(".confirm_tweet").html('');
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
 
  $( "#buscar" ).click(function(e) {
    e.preventDefault();
    
    termino = $("#termino").val()
    opcion = $('input[name=opcion]:checked').val()
    
    if(termino!="" || (termino=="" && opcion=="timeline"))
    {
      $('#error').html() 
      if(opcion == "usuario")
      {
        while(termino.charAt(0) === '@')
          termino = termino.substr(1)
      }
      else if(opcion =="hashtag")
      {
        while(termino.charAt(0) === '#')
          termino = termino.substr(1)
      }
      else if(opcion =="termino")
      {
        if(termino[0]=='#')
        {
          while(termino.charAt(0) === '#')
            termino = termino.substr(1)
          opcion = "hashtag"
        }
      }      
      var url = '/buscar/'+opcion+"/"+termino; 
      $(location).attr('href',url);
    }
    else
      $('#error').html("Escribe algo en tu búsqueda") 
	});  
  
    $(window).scroll(function(){
      if( $(window).width()>767){
        $('.video_cont').css('margin-top',$(window).scrollTop()+10);
      }
      else { $('.video_cont').css('margin-top',10); }
    });
  
    $( "#ver_mas" ).click(function() { 
      $('.twcard.oculto').slice(0,8).fadeIn('fast').removeClass('oculto');
        if($('.twcard.oculto').length == 0)
          $( "#ver_mas" ).fadeOut();
    });
  
  if($('.widget_content')[0]){ 
    $('.widget_content').css('height', $(document).height()-131);
  }  
  
});

function contarCaracteres(){
  
  $(".caracteres").html(140-$(".texttweet").val().length)
      
  if($(".texttweet").val().length > 130)
    $(".caracteres").css({ color: "#ff0000"});
  else
    $(".caracteres").css({ color: "#777"});
}



/*
$(window).onResize(function() {
   if( $(window).width()<767){
     $('.video_cont').css('margin-top',10);
   }
  
  //Falta alto widget (resta)
});*/
