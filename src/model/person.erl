-module(person, [Id, Name, Email, Password]).
-compile(export_all).

-has({messages, many}).

%session_identifier() ->
  %mochihex:to_hex(erlang:md5("SS" ++ Id)).

%check_password(Password) ->
  %Salt = mochihex:to_hex(erlang:md5(Email)),
  %user_lib:hash_password(Password, Salt) =:= PasswordHash.

%login_cookies() ->
  %[ mochiweb_cookies:cookie("user_id", Id, [{path, "/"}]),
    %mochiweb_cookies:cookie("session_id", session_identifier(), [{path, "/"}]) ].
