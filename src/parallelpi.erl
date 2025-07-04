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
    sup_manager:start_link().

