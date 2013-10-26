$(document).ready(function() {

    // Create a WebSocket object.
    // ws://localhost:8001
    wsc = new WebSocket("ws://localhost:8001/websocket/chat_protocol", "chat_protocol");

    // Send message to server.
    $("#new-message").submit(function(event) {
        //var name = $("#name").val();
        //var email = $("#email").val();
        //var msg = $("#msg").val();
        var json = {};
        $.each($(this).serializeArray(), function() { json[this.name] = this.value; });
        var data = JSON.stringify(json);
        //var value = '<div><b>' + name + ':</b> ' + msg;
        console.log('sending: ' + data);
        $("#msg").val('').focus();
        wsc.send(data);

        return false;
    })

    // Receive message from server.
    wsc.onmessage = function(event) {
        var data = JSON.parse(event.data);

        template = $('.template').clone().removeClass('template');
        template.show();
        var hash = CryptoJS.MD5(data.email);
        var avatar = 'http://www.gravatar.com/avatar/' + hash
        template.find('img').attr('src', avatar)
        template.find('.text').text(data.message)
        template.find('.name').text(data.name)

        $('#msgs').prepend(template);
    }

});

