-module(chat_hello_controller, [Req]).
-compile(export_all).

hello('GET', []) ->
    {output, "<strong>Hello erlang!</strong>"}.
