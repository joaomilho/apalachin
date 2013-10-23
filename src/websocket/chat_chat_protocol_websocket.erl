-module(chat_chat_protocol_websocket).
-behaviour(boss_service_handler).

-record(state,{users, messages}).

%% API
-export([
    init/0,
	handle_incoming/5,
	handle_join/4,
	handle_close/4,
	handle_info/2,
	terminate/2
    ]).

init() ->
    NewState = #state{users=[], messages=[]},
    error_logger:info_msg("(init) ~p~n", [NewState]),
    {ok, NewState}.

handle_join(ServiceName, WebSocketId, SessionId, State) ->
    error_logger:info_msg("(handle_join) ~p / ~p / ~p / ~p~n", [
            ServiceName, WebSocketId, SessionId, State]),

    #state{users=Users, messages=Messages} = State,

    error_logger:info_msg("(handle_join2) ~p~n", [Users]),

    AfterJoinState = #state{users=[WebSocketId|Users], messages=Messages},

    error_logger:info_msg("(handle_join3) ~p~n", [AfterJoinState]),

    {reply, ok, AfterJoinState}.

handle_close(ServiceName, WebSocketId, SessionId, State) ->
    error_logger:info_msg("(handle_close) ~p / ~p / ~p / ~p~n", [
            ServiceName, WebSocketId, SessionId, State]),
    {reply, ok, State}.

handle_incoming(ServiceName, WebSocketId, SessionId, Message, State) ->
    error_logger:info_msg("(handle_incoming) ~p / ~p / ~p / ~p / ~p~n", [
            ServiceName, WebSocketId, SessionId, Message, State]),

    #state{users=Users, messages=Messages} = State,
    AfterIncomingState = #state{users=Users, messages=[Message|Messages]},
    error_logger:info_msg("(handle_incoming2) ~p~n", [AfterIncomingState]),

    lists:map(fun(User) -> User ! {text, Message} end , Users),

    {noreply, AfterIncomingState}.

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
