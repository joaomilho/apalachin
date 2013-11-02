$(document).ready(function() {

  user_id = $('[data-me]').attr('id');

  scroll_messages = function(){
    var height = $( "ul#messages" )[0].scrollHeight;
    $( "ul#messages" ).scrollTop( height );
  }

  heights = function(){
    aside_height = $(window).height() - $('nav').height() - 40
    messages_height = aside_height - $('input').height() - 70
    $('ul#messages').height( messages_height )
    $('aside').height( aside_height )
    scroll_messages()
  }

  function avatar(id){
    try{
      var hash = CryptoJS.MD5($('#'+id).data('email'));
      return 'http://www.gravatar.com/avatar/' + hash
    }catch(e){
      return '/static/img/default-avatar.jpeg'
    }
  }

  $("#new-message").submit(function(event) {
    var input = $("input[name='message']");
    var msg = input.val();
    input.val('').focus();
    wsc.send(msg);

    create_message([user_id, msg]);
    im_typing = false;
    return false;
  })

  ENTER = 13;
  im_typing = false;
  $("input[name='message']").keyup(function(event){
    if(event.which != ENTER && !im_typing && $(this).val()){
      wsc.send("typing");
      im_typing = true;
    }
  })


  typings = {};

  function show_typing(id){
    if(typings[id]) return;

    template = show_message(id, '<span class="typing">&bull;&bull;&bull;</span>');
    typings[id] = template;
    template.find('.time').remove();
  }

  function show_users(user_list){
    $(user_list).each(function(){
      $("#"+this).addClass('online');
    })
  }

  function show_image(url){
    alert(url);
    if(/\.(gif|png|jpe?g)$/i.test(url))
      return '<img src="' + url + '">';
    else
      return null;
  }

  function create_message(msg){
    id = msg.shift();
    message = msg.shift();
    if(typings[id]){
      typings[id].hide();
      typings[id] = null;
    }
    show_message(id, message);
  }

  function show_message(id, message){
    template = $('.template').clone().removeClass('template');
    template.addClass(user_id == id ? 'left' : 'right');

    template.show();
    template.find('img').attr('src', avatar(id));
    template.find('.text').html(message.autoLink({ target: "_blank", callback: show_image }));

    var now = new Date();
    var hour = now.getHours();
    var minutes = now.getMinutes();

    template.find('.time').text(hour + ':' + minutes)

    $('#messages').append(template);
    scroll_messages()
    return template;
  }

  ws_receive_message = function(event) {
    var data = JSON.parse(event.data);
    command = data[0];

    switch(command){
    case "user_list":
      show_users(data[1]);
      break;
    case "message":
      create_message(data[1]);
      break;
    case "typing":
      show_typing(data[1]);
      break;
    }
  }

  wsc = new WebSocket("ws://localhost:8001/websocket/chat_protocol", "chat_protocol");

  wsc.onmessage = ws_receive_message;
  $(window).resize(heights);
  heights();

});
