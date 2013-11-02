-module(chat_chat_protocol_websocket).
-behaviour(boss_service_handler).

-record(state, {users}).

-compile(export_all).

user_id(Sess) ->
  boss_session:get_session_data(binary_to_list(Sess), user_id).

init() ->
  {ok, #state{users=dict:new()}}.

user_list(Users) ->
  lists:map(fun(X) -> list_to_binary(X) end, dict:fetch_keys(Users)).

values(Dict) ->
  list_values(dict:to_list(Dict)).

list_values(List) ->
  lists:map(fun({_,V}) -> V end, List).

values_except_key(Key, Dict) ->
  FilteredList = lists:filter(fun({K,_}) -> Key =/= K end, dict:to_list(Dict)),
  list_values(FilteredList).

notify_all(Notification, #state{users=Users}) ->
  Connections = values(Users),
  EncodedNotification = jsx:encode(Notification),
  lists:map(fun(Conn) -> Conn ! {text, EncodedNotification} end, Connections).

notify_all_except_me(Notification, User, #state{users=Users}) ->
  Connections = values_except_key(User:id(), Users),
  EncodedNotification = jsx:encode(Notification),
  lists:map(fun(Conn) -> Conn ! {text, EncodedNotification} end, Connections).

save_message(User, MessageText) ->
  Message = message:new(id, User:id(), MessageText, erlang:now()),
  Message:save().

handle_join(_, WebSocketId, SessionId, State) ->
  case SessionId of
    undefined ->
      {stop, "Auth", State};
    SessionIdOk ->
      case user_id(SessionId) of
        undefined ->
          {stop, "Auth", State};
        UserId ->
          case boss_db:find(UserId) of
            undefined ->
              {stop, "Auth", State};
            User ->
              #state{users=Users} = State,
              UpdatedUsers = dict:store(UserId, WebSocketId, Users),
              AfterJoinState = #state{users=UpdatedUsers},

              Notification = [<<"user_list">>, user_list(UpdatedUsers)],
              notify_all(Notification, AfterJoinState),
              {reply, ok, AfterJoinState}
      end
    end
  end.

handle_close(ServiceName, WebSocketId, SessionId, State) ->
    {reply, ok, State}.

handle_incoming(_, WebSocketId, SessionId, Message, State) ->
    UserId = user_id(SessionId),
    case boss_db:find(UserId) of
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


handle_info(ping,  State) -> {noreply, State};
handle_info(state, State) -> {noreply, State};
handle_info(_,     State) -> {noreply, State}.


terminate(Reason, State) -> ok.
