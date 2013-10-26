-module(chat_chat_controller, [Req, Sess]).
-compile(export_all).

user_id() ->
  boss_session:get_session_data(Sess, user_id).

before_(_) ->
  auth_lib:auth(user_id()).

index('GET', [], User) ->
  error_logger:info_msg("((chat/index)) ~p / ~p~n", [Sess, user_id()]),
  {ok, [{user, User}]}.
