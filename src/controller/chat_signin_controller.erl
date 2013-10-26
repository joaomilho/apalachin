-module(chat_signin_controller, [Req, Sess]).
-compile(export_all).

create('POST', []) ->
  Email = Req:post_param("email"),
  Password = Req:post_param("password"),

  case auth_lib:signin(Email, Password) of

    [User] ->
      boss_session:set_session_data(Sess, user_id, User:id()),
      {redirect, "/chat/index"};

    [] -> {redirect, "/signin/new"}

  end.
