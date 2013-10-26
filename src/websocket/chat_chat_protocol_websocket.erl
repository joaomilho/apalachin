-module(chat_chat_protocol_websocket).
-behaviour(boss_service_handler).

%-record(state,{usersi, ids}).
%-record(state, {users}).
-record(state, {users}).


%% API
-export([
    init/0,
    handle_incoming/5,
    handle_join/4,
    handle_close/4,
    handle_info/2,
    terminate/2
  ]).

user_id(Sess) ->
  boss_session:get_session_data(binary_to_list(Sess), user_id).

init() ->
  {ok, #state{users=dict:new()}}.

user_list(Users) ->
  lists:map(fun(X) -> list_to_binary(X) end, dict:fetch_keys(Users)).

values(Dict) ->
  lists:map(fun({_,V}) -> V end, dict:to_list(Dict)).

notify_all(Notification, #state{users=Users}) ->
  Connections = values(Users),
  EncodedNotification = jsx:encode(Notification),
  lists:map(fun(Conn) -> Conn ! {text, EncodedNotification} end, Connections).

handle_join(_, WebSocketId, SessionId, State) ->
  error_logger:info_msg("(handle_join) >>>>>>> ~p / ~p / ~p~n", [
          WebSocketId, SessionId, State]),
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
    error_logger:info_msg("(handle_close) ~p / ~p / ~p / ~p~n", [
            ServiceName, WebSocketId, SessionId, State]),
    {reply, ok, State}.

handle_incoming(_, WebSocketId, SessionId, Message, State) ->
    error_logger:info_msg("(handle_incoming) ~p / ~p / ~p / ~p~n", [
            WebSocketId, SessionId, Message, State]),


    %AfterIncomingState = #state{users=Users, messages=[Message|Messages]},
    %error_logger:info_msg("(handle_incoming2) ~p~n", [AfterIncomingState]),
    UserId = user_id(SessionId),
    case boss_db:find(UserId) of
      undefined ->
        {stop, "Auth", State};
      User ->
        Notification = case Message of
          <<"typing">> ->
            [<<"typing">>, list_to_binary(User:id())];
          _ ->
            Data = [{user_id, list_to_binary(User:id())},{name, User:name()}, {email, User:email()}, {message, Message}],
            [<<"message">>, Data]
        end,

        notify_all(Notification, State),

        {noreply, State}
    end.

handle_info(ping, State) ->
    error_logger:info_msg("(handle_info,ping) State: ~p~n", [State]),
    {noreply, State};
handle_info(state, State) ->
    error_logger:info_msg("(handle_info,state) State:~p~n", [State]),
    {noreply, State};
handle_info(Info, State) ->
    error_logger:info_msg("(handle_info,Info) State:~p / ~p~n", [Info, State]),
    {noreply, State}.

terminate(Reason, State) ->
    error_logger:info_msg("(terminate) ~p / ~p~n", [Reason, State]),
    %call boss_service:unregister(?SERVER),
    ok.
