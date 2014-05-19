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
  
  
  $( ".fav" ).click(function() {
    var opcion = "";
    if(!$(this).hasClass('true')){
      $(this).addClass('true'); 
      opcion = "/favorite";
    }
    else{
      $(this).addClass('true'); 
      opcion = "/unfavorite";
      $(this).removeClass('true');
      
    }
	  $.ajax({type: 'get', 
	  	url: opcion,
      data: { tuit_id:  $(this).attr('id') },  
	  	success: function (response) { $( ".confirm_tweet" ).append(response); }, 
	  	error: function(response) {  $( ".confirm_tweet" ).append(response); }
	   });
    
    if($('.all_fav_tweets')[0]){
      $(this).closest( ".twcard" ).fadeOut();
      setTimeout(function(){
        $('.twcard.oculto').eq(0).fadeIn('fast').removeClass('oculto');
        if($('.twcard.oculto').length == 0)
          $( "#ver_mas" ).fadeOut();
      }, 1000);
      
    }
	  return(false); 
	});
  
  $( ".rt" ).click(function() {
    var opcion = ""
    if(!$(this).hasClass('true')){
      $(this).addClass('true'); 
      opcion = "/retweet";
    }
    else{
      $(this).removeClass('true'); 
      opcion = "/unretweet";
    }
	  $.ajax({type: 'get', 
	  	url: opcion,
      data: { tuit_id:  $(this).attr('id') },  
	  	success: function (response) { $( ".confirm_tweet" ).append(response); }, 
	  	error: function(response) {  $( ".confirm_tweet" ).append(response); }
	   });
	  return(false); 
	});
  
/*
  
    $( ".rt" ).click(function() {
      //alert($(this).attr('id'));
      $(this).addClass('true');
      $(this).removeClass('rt');
      $(this).addClass('unrt');
	  $.ajax({type: 'get', 
	  	url: "retweet",
      data: { tuit_id:  $(this).attr('id') },  
	  	success: function (response) {  $( ".confirm_tweet" ).append(response); }, 
	  	error: function(response) { $( ".confirm_tweet" ).append(response); }
	   });
	  return(false); 
	});
  
    $( ".unrt" ).click(function() {
      //alert($(this).attr('id'));
    $(this).removeClass('true');
    $(this).addClass('rt');
    $(this).removeClass('unrt');
	  $.ajax({type: 'get', 
	  	url: "unretweet",
      data: { tuit_id:  $(this).attr('id') },  
	  	success: function (response) {  $( ".confirm_tweet" ).append(response); }, 
	  	error: function(response) { $( ".confirm_tweet" ).append(response); }
	   });
	  return(false); 
	});*/
  
   ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// FALTA DELETE
  
   /* Fin Acciones de un tweet  */


  /* RSS */
  
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
  
  $( "#btn_guardar_rss" ).click(function(e) {
    e.preventDefault();
	  $.ajax({type: 'get',   url: "rss/guarda_rss/"+$('#rss_tipo').val()+"/"+$('#rss_termino').val(),
	  	success: function (response) { }, 
	  	error: function() {}
	  });
    $( ".all_rss").fadeOut();  
    recargarRSS();
	  return(false); 
	});
  

  
  $( ".borrar_rss" ).click(function(e) {
    e.preventDefault();
    var url = $(this).attr("href");
	  $.ajax({type: 'get',   url: url,
	  	success: function (response) { }, 
	  	error: function() {}
	  });
    $(this).closest("article.item_rss").slideUp();
	  return(false); 
	});
  
    function recargarRSS(){
        $.ajax({type: 'get',   url: "rss/all_rss",
        success: function (response) {
                  $( ".all_rss" ).html(response);  
                  $( ".all_rss").fadeIn();                  
        }, 
        error: function() {  }  });
        return(false);    
  }
  
    /* Fin rss */
  
  /* Perfil borrar una búsqueda */
    
  $( ".delete_item" ).click(function(e) {
    e.preventDefault();
    var url = $(this).attr("href");
	  $.ajax({type: 'get',   url: url,
	  	success: function (response) { }, 
	  	error: function() {}
	  });
    $(this).closest("article.item_search").toggle("left");
	  return(false); 
	});
   
  /* Busqueda avanzada */
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
        $('#termino').css('visibility', 'hidden');
        $('#termino').val("");
        $('#termino').attr('disabled', true);
        $('#error').html("") 
      }
      else
      { 
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
  
  /* Fin Busqueda avanzada */
  
  /* Nuevo Tweet */
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
  /* Fin Nuevo Tweet */
  

  
  $( "#bt_ver_evento" ).click(function() {
    var hashtag = $("#ht_evento").val();
	  $.ajax({type: 'get', 
	  	url: "evento/live", 
      data: { idvideo:  $("#id_video").val(), hashtag:  $("#ht_evento").val() },
	  	success: function (response) {
          $( ".evento_container" ).html(response);
          setTimeout(function(){  actualizar_evento(hashtag); }, 20000);
      }, 
	  	error: function() { $( ".evento_container" ).append('Error al enviar!'); }
	   });
	  return(false); 
	});
  var update_count = 0;
    function actualizar_evento (hashtag){
      var class_id= $(".twcard").eq(0).attr('class');
      var class_id = class_id.split("_");
      var id = class_id[class_id.length-1];
      update_count++;
      console.log('UPDATE: '+update_count);
      $.ajax({type: 'get', 
	  	url: "evento/update", 
              data: { id_since:id , hashtag:  hashtag },
	  	        success: function (response) {
              //$( ".evento_twcard_cont" ).prepend('<p> UPDATE '+update_count+'</p>');
              $( ".evento_twcard_cont" ).prepend(response);
      }, 
	  	error: function() { $( ".evento_twcard_cont" ).append('Error al enviar!'); }
	   });
      setTimeout(function(){ actualizar_evento(hashtag); }, 20000);
      return(false);
      
    }
  
  /* Buscar */
 
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
  
  /* Fin Buscar */
  
 
  $( "#guardar_busqueda" ).click(function(e) {
    var str = document.URL;
    var res = str.split("/");
    var tipo = res[res.length-2]
    var termino = res[res.length-1]
    var url = '/buscar/guardar_busq/'+tipo+"/"+termino;    
    $(location).attr('href',url);    
	  return(false);    
	});
    
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// HACER BORRAR BUSQUEDA
  
  
  /* Evento */
    $(window).scroll(function(){
      if( $(window).width()>767){
        $('.video_cont').css('margin-top',$(window).scrollTop()+10);
      }
      else { $('.video_cont').css('margin-top',10); }
    });
  
    $( "#ver_mas" ).click(function() { 
      $('.twcard.oculto').slice(0,6).fadeIn('fast').removeClass('oculto');
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

