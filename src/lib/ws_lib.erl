-module(ws_lib).
-export([notify_all/2, notify_all_except_me/3]).

-record(state, {users}).

notify_all(Notification, #state{users=Users}) ->
  notify(Notification, values(Users)).

notify_all_except_me(Notification, User, #state{users=Users}) ->
  notify(Notification, values_except_key(User:id(), Users)).

% private

notify(Notification, Connections) ->
  EncodedNotification = jsx:encode(Notification),
  lists:map(fun(Conn) -> Conn ! {text, EncodedNotification} end, Connections).

values_except_key(Key, Dict) ->
  FilteredList = lists:filter(fun({K,_}) -> Key =/= K end, dict:to_list(Dict)),
  list_values(FilteredList).

values(Dict) ->
  list_values(dict:to_list(Dict)).

list_values(List) ->
  lists:map(fun({_,V}) -> V end, List).

