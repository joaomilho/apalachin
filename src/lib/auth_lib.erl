-module(auth_lib).
-compile(export_all).

redirect_to_signin() ->
  {redirect, "/signin/new"}.

signin(Email, Password) ->
  boss_db:find(person, [{email, Email}, {password, Password}]).

auth(UserId) ->
  case find_user_by_id(UserId) of
    undefined -> redirect_to_signin();
    User -> {ok, User}
  end.

find_user_by_session(SessionId) ->
  find_user_by_id(get_user_id_by_session(SessionId)).

find_user_by_id(UserId) ->
  case boss_db:find(UserId) of
    {error, _} -> undefined;
    undefined  -> undefined;
    User       -> User
  end.

get_user_id_by_session(SessionId) ->
  case SessionId of
    undefined -> undefined;
    _ -> boss_session:get_session_data(binary_to_list(SessionId), user_id)
  end.

