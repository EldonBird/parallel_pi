%%%-------------------------------------------------------------------
%%% @author Eldon
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Jun 2025 22:20
%%%-------------------------------------------------------------------
-module(gen_worker_long).
-behavior(gen_server).
-author("Eldon").

%% API
-export([
  handle_cast/2,
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

handle_cast({long, ManagerPid}, State) ->
  Jump = 1000000,
  {Prev_Total, Prev_Inside} = State,
  Result = monte_carlo(Jump, Prev_Total),
  gen_server:cast(ManagerPid, {result, Result}),
  gen_server:cast(self(), {long, ManagerPid}),
  {Running_Total, Running_Inside} = Result,
  {noreply, {Prev_Total + Running_Total, Prev_Inside + Running_Inside}}.



halton(_, 0, Result, _) ->
  Result;
halton(Radix, Index, Result, Weight) when Index > 0 ->
  NewWeight = Weight / Radix,
  Nominator = Index rem Radix,
  NewResult = (Nominator * NewWeight) + Result,
  NewIndex = Index div Radix,
  halton(Radix, NewIndex, NewResult, NewWeight).

generate_points(PointNum, EndPoint) when PointNum >= EndPoint ->
  [];
generate_points(PointNum, EndPoint) ->

  X = halton(2, PointNum, 0, 1),
  Y = halton(3, PointNum, 0, 1),

  Temp = {X, Y},

  [Temp | generate_points(PointNum + 1, EndPoint)].


count_points([]) ->
  0;
count_points([{X, Y} | Tail]) when (X*X) + (Y*Y) =< 1 ->
  1 + count_points(Tail);
count_points([_ | Tail]) ->
  count_points(Tail).

monte_carlo(Jump, CurrentPoint) ->

  All_points = generate_points(CurrentPoint, CurrentPoint + Jump),
  Inside_Points = count_points(All_points),
  {Jump, Inside_Points}.