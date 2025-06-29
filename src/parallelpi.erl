%%%-------------------------------------------------------------------
%%% @author Eldon
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Jun 2025 21:47
%%%-------------------------------------------------------------------
-module(parallelpi).
-author("Eldon").

%% API
-export([start/0]).

start() ->
    man_sup:start_link().

