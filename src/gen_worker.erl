%%%-------------------------------------------------------------------
%%% @author Eldon
%%% @copyright (C) 2025, Eldon Bait and Tackle
%%% @doc
%%%
%%% @end
%%% Created : 28. Jun 2025 19:15
%%%-------------------------------------------------------------------
-module(gen_worker).
-author("Birdh").

%% API
-export([]).


%% For the initial call you should use Result = 0, Weight = 1

halton(_, 0, Result, _) ->
    Result;
halton(Radix, Index, Result, Weight) when Index > 0 ->
    NewWeight = Weight / Radix,
    Nominator = Index rem Radix,
    NewResult = (Nominator * NewWeight) + Result,
    NewIndex = Index div Radix,
    halton(Radix, NewIndex, NewResult, NewWeight).


generate_points(0, _) ->
    [];
generate_points(PointNum, Size) ->

    X = halton(2, PointNum, 0, 1) * Size,
    Y = halton(3, PointNum, 0, 1) * Size,

    Temp = {X, Y},

    [Temp | generate_points(PointNum - 1, Size)].















