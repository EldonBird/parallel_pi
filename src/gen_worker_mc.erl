%%%-------------------------------------------------------------------
%%% @author Eldon
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Jun 2025 22:20
%%%-------------------------------------------------------------------
-module(gen_worker_mc).
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

handle_cast({mc, ManagerPid, Offset}, State) ->
  Jump = 1000000,
  {Prev_Total, Prev_Inside} = State,
  Result = monte_carlo(Jump, Prev_Total + Jump * Offset),
  gen_server:cast(ManagerPid, {result_mc, Result}),
  gen_server:cast(self(), {long, ManagerPid, Offset}),
  {_, Running_Inside} = Result,
  {noreply, {Prev_Total + Jump, Prev_Inside + Running_Inside}}.

handle_call({}, _From, State) ->
  {reply, State, State}.





%% Monte Carlo Method

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


%% Monte Carlo Method
