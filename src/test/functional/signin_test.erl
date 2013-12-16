-module(signin_test).
-export([start/0]).

redirect_to(Path) ->
  [
   fun boss_assert:http_redirect/1,
   fun(Response) -> boss_assert:location_header(Path, Response) end
  ].

have_label(Text) ->
  fun(Page) ->
    boss_assert:tag_with_text("label", Text, Page)
  end.

start() ->

  boss_web_test:get_request("/", [],
    redirect_to("/signin/new"), [
      "Redirect to signin when not signed",
      fun(SignInPage) ->
        boss_web_test:follow_redirect(SignInPage,
          [
           fun boss_assert:http_ok/1,
           have_label("Email"),
           have_label("Password")
          ], [])
      end,

      "Post incorrect data",
      fun(SignInPage) ->
        boss_web_test:post_request("/signin/create", [], "email=john@doe.com&password=1234",
          redirect_to("/signin/new"), [])
      end,

      "Post correct data",
      fun(SignInPage) ->
        User = person:new(id, "John Doe", "john@doe.com", "1234"),
        User:save(),

        boss_web_test:post_request("/signin/create", [], "email=john@doe.com&password=1234",
          redirect_to("/chat/index"), [
            "Go to chat",
            fun(HomePage) ->
              boss_web_test:follow_redirect(HomePage,
                [
                 fun boss_assert:http_ok/1
                ], [])
            end
          ])
      end

    ]).
