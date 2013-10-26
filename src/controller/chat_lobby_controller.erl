-module(chat_lobby_controller, [Req]).
-compile(export_all).

index('GET', []) ->
  {ok, []}.
