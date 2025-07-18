%%%-------------------------------------------------------------------
%%% @author Eldon
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Jun 2025 22:20
%%%-------------------------------------------------------------------
-module(gen_worker_new).
-author("Eldon").
-behavior(gen_server).

%% API
-export([
  handle_cast/2,
  handle_call/3,
  init/1,
  terminate/2,
  start_link/0
]).

init([]) ->
  {ok, {0, 0}}.

start_link() ->
  gen_server:start_link(?MODULE, [], []).

terminate(_Reason, _State) -> ok.



%                                                  true = on false = off
% When you are using a long calcuation the state is = {ContinueFlag, {Inside, Total}}

handle_cast({mc, ManagerPid, Start, End}, State) ->

  .

handle_call({}, _From, State) ->
  {reply, State, State}.
