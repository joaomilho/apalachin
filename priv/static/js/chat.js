$(document).ready(function() {

    $('#users li').each(function(){
      $(this).find('img').each(function(){
        var hash = CryptoJS.MD5($(this).data('email'));
        var avatar = 'http://www.gravatar.com/avatar/' + hash

        $(this).attr('src', avatar);
      })
    })

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
        wsc.send(msg);

        return false;
    })

    $("input[name='message']").keyup(function(){
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

    function show_typing(user_id){
      //TODO User the timer!
      $('#'+user_id).find('.typing').show();
    }

    function show_users(user_list){
      $(user_list).each(function(){
        $("#"+this).addClass('online');
      })
    }

    function create_message(msg){
      console.log("message:", msg);
      $('#'+msg.user_id).find('.typing').hide();

      template = $('.template').clone().removeClass('template');
      template.show();
      var hash = CryptoJS.MD5(msg.email);
      var avatar = 'http://www.gravatar.com/avatar/' + hash
      template.find('img').attr('src', avatar)
      template.find('.text').text(msg.message)
      template.find('.name').text(msg.name)

      $('#msgs').prepend(template);
    }

});



