$(document).ready(function() {

    user_id = $('[data-me]').attr('id');

    function avatar(id){
      var hash = CryptoJS.MD5($('#'+id).data('email'));
      return 'http://www.gravatar.com/avatar/' + hash
    }

    // Create a WebSocket object.
    // ws://localhost:8001
    wsc = new WebSocket("ws://localhost:8001/websocket/chat_protocol", "chat_protocol");

    // Send message to server.
    $("#new-message").submit(function(event) {
        //var name = $("#name").val();
        //var email = $("#email").val();
        var input = $("input[name='message']");
        var msg = input.val();
        //var json = {};
        //$.each($(this).serializeArray(), function() { json[this.name] = this.value; });
        //var data = JSON.stringify(json);
        //var value = '<div><b>' + name + ':</b> ' + msg;
        console.log('sending: ' + msg);
        input.val('').focus();
        //alert('a')
        wsc.send(msg);
        //alert('b')

        create_message([user_id, msg]);
        return false;
    })

    ENTER = 13;
    $("input[name='message']").keyup(function(event){
      if(event.which != ENTER)
        wsc.send("typing");
    })


    // Receive message from server.
    wsc.onmessage = function(event) {
        var data = JSON.parse(event.data);
        //alert(data)
        command = data[0];
        //alert(command)
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

    typings = {};
    //typing_img = $('<img src="/static/img/typing.png" style="width:24px;" />')

    function show_typing(id){
      //TODO Use the timer!
      //$('#'+user_id).find('.typing').show();
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

    function create_message(msg){
      console.log("message:", msg);
      id = msg.shift();
      message = msg.shift();
      //$('#'+msg.user_id).find('.typing').hide();
      if(typings[id]){
        typings[id].hide();
        typings[id] = null;
      }
      show_message(id, message);

    }

    function show_message(id, message){
      template = $('.template').clone().removeClass('template');
      template.addClass(user_id == id ? 'left' : 'right')

      template.show();
      //avatar = $('#'+id).find('img').attr('src')
      template.find('img').attr('src', avatar(id))
      template.find('.text').html(message)
      //template.find('.name').text(msg.name)

      $('#messages').prepend(template);
      return template;
    }

});



