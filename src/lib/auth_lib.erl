-module(auth_lib).
-compile(export_all).

redirect_to_signin() ->
  {redirect, "/signin/new"}.

signin(Email, Password) ->
  boss_db:find(person, [{email, Email}, {password, Password}]).

auth(UserId) ->
  case UserId of
    undefined -> redirect_to_signin();
    Id ->
      case boss_db:find(Id) of
        undefined -> redirect_to_signin();
        User -> {ok, User}
      end
   end.
