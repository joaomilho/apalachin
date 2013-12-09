-module(chat_chat_protocol_websocket).
-behaviour(boss_service_handler).

-record(state, {users}).

-compile(export_all).
-import(ws_lib, [notify_all/2, notify_all_except_me/3]).

% helpers

user_list(Users) ->
  lists:map(fun(X) -> list_to_binary(X) end, dict:fetch_keys(Users)).

save_message(User, MessageText) ->
  Message = message:new(id, User:id(), MessageText, erlang:now()),
  Message:save().

% protocol methods

init() ->
  {ok, #state{users=dict:new()}}.

handle_join(_, WebSocketId, SessionId, State) ->

  case auth_lib:find_user_by_session(SessionId) of
    undefined ->
      {stop, "Auth", State};
    User ->
      #state{users=Users} = State,
      UpdatedUsers = dict:store(User:id(), WebSocketId, Users),
      AfterJoinState = #state{users=UpdatedUsers},

      Notification = [<<"user_list">>, user_list(UpdatedUsers)],
      notify_all(Notification, AfterJoinState),
      {reply, ok, AfterJoinState}
  end.

handle_close(ServiceName, WebSocketId, SessionId, State) ->
  {reply, ok, State}.

handle_incoming(_, WebSocketId, SessionId, Message, State) ->

  case auth_lib:find_user_by_session(SessionId) of
    undefined ->
      {stop, "Auth", State};
    User ->
      Notification = case Message of
        <<"typing">> ->
          Data = list_to_binary(User:id()),
          [<<"typing">>, Data];
        _ ->
         Data = [list_to_binary(User:id()), Message],
         save_message(User, Message),
          [<<"message">>, Data]
      end,

      notify_all_except_me(Notification, User, State),

      {noreply, State}
  end.


handle_info(ping,  State) ->
  {noreply, State};
handle_info(state, State) ->
  {noreply, State};
handle_info(_,     State) ->
  {noreply, State}.

terminate(Reason, State) ->
  ok.
