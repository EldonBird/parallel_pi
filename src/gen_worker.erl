%%%-------------------------------------------------------------------
%%% @author Eldon
%%% @copyright (C) 2025, Eldon Bait and Tackle
%%% @doc
%%%
%%% @end
%%% Created : 28. Jun 2025 19:15
%%%-------------------------------------------------------------------
-module(gen_worker).
-behaviour(gen_server).
-author("Eldon").


% State = [{inside_count, total_count}}, ...]

%% API
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    terminate/2,
    start_link/0
]).


init([]) ->
    {ok, []}.

start_link() ->
    gen_server:start_link(?MODULE, [], []).

%% gen server calls

%% apparnetly I dont really need these since I am calling them directly from my manager function, I am going to leave them in,
%% as decoration though!

% calculate(Start, End) ->
%    gen_server:cast(?MODULE, {calculate, Start, End}).

% get_result() ->
%     gen_server:call(?MODULE, {last}).

% get_all() ->
%     gen_server:call(?MODULE, {all}).

% Handle Casts and Calls,



handle_cast({calculate, Start, End}, State) ->
    Result = monte_carlo(Start, End),
    New_State = [Result | State],
    {noreply, New_State}.



handle_call({last}, _From, State) ->
    [Result | _] = State,
    {reply, Result, State};
handle_call({all}, _From, State) ->
    {reply, State, State};
handle_call({endflag}, _From, State) ->
    {_, {Inside, Total}} = State,
    
    {reply, {Inside, Total},{endflag, {Inside, Total}}},
    terminate(_, _).
    
    

terminate(_Reason, _State) -> ok.



%% For the initial call you should use Result = 0, Weight = 1

halton(_, 0, Result, _) ->
    Result;
halton(Radix, Index, Result, Weight) when Index > 0 ->
    NewWeight = Weight / Radix,
    Nominator = Index rem Radix,
    NewResult = (Nominator * NewWeight) + Result,
    NewIndex = Index div Radix,
    halton(Radix, NewIndex, NewResult, NewWeight).


% Point num is the current point number, so to start from 1000, put it as 1000, endp defines the total range to calculate for.

generate_points(PointNum, EndPoint) when PointNum >= EndPoint ->
    [];
generate_points(PointNum, EndPoint) ->

    X = halton(2, PointNum, 0, 1),
    Y = halton(3, PointNum, 0, 1),

    Temp = {X, Y},

    [Temp | generate_points(PointNum + 1, EndPoint)].


% Counts the number of points that are inside the 4th of the circle

count_points([]) ->
    0;
count_points([{X, Y} | Tail]) when (X*X) + (Y*Y) =< 1 ->
    1 + count_points(Tail);
count_points([_ | Tail]) ->
    count_points(Tail).




monte_carlo(Origin, EndPoint) ->

    All_points = generate_points(Origin, EndPoint),
    Inside_Points = count_points(All_points),

    % {Total, Inside Points}
    {EndPoint - Origin, Inside_Points}.




    
    








