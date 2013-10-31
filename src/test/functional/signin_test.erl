-module(signin_test).
-export([start/0]).

redirect_to(Path) ->
  [
   fun boss_assert:http_redirect/1,
   fun(Response) -> boss_assert:location_header(Path, Response) end
  ].

start() ->
  boss_web_test:get_request("/", [],
    redirect_to("/signin/new"), []).

