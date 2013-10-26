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
  %NewState = #state{users=[]},
  %error_logger:info_msg("(init) ~p~n", [NewState]),
  %{ok, NewState}.
  {ok, #state{users=dict:new()}}.

handle_join(_, WebSocketId, SessionId, State) ->
  error_logger:info_msg("(handle_join) ~p / ~p / ~p / ~p~n", [
          WebSocketId, SessionId, State, user_id(SessionId)]),
  UserId = user_id(SessionId),
  case boss_db:find(UserId) of
    undefined ->
      {stop, "Auth", State};
    User ->
      #state{users=Users} = State,
      %AfterJoinState = #state{users=[WebSocketId|Users], messages=Messages},
      AfterJoinState = #state{users=dict:store(UserId, WebSocketId, Users)},
      {reply, ok, AfterJoinState}
      %{reply, ok, AfterJoinState}
  end.


handle_close(ServiceName, WebSocketId, SessionId, State) ->
    error_logger:info_msg("(handle_close) ~p / ~p / ~p / ~p~n", [
            ServiceName, WebSocketId, SessionId, State]),
    {reply, ok, State}.

handle_incoming(ServiceName, WebSocketId, SessionId, Message, State) ->
    error_logger:info_msg("(handle_incoming) ~p / ~p / ~p / ~p / ~p~n", [
            ServiceName, WebSocketId, SessionId, Message, State]),

    #state{users=Users} = State,
    %AfterIncomingState = #state{users=Users, messages=[Message|Messages]},
    %error_logger:info_msg("(handle_incoming2) ~p~n", [AfterIncomingState]),

    lists:map(fun(User) -> User ! {text, Message} end , Users),

    {noreply, State}.

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
