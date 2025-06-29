%%%-------------------------------------------------------------------
%%% @author Eldon
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Jun 2025 21:47
%%%-------------------------------------------------------------------
-module(parrallelpi).
-author("Eldon").

%% API
-export([start/0]).

start() ->
    gen_sup:start_link().

