%%%-------------------------------------------------------------------
%%% @author Eldon
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Jun 2025 19:16
%%% -------------------------------------------------------------------

-module(gen_sup).
-author("Eldon").
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).



%% HAD TO USE INTERNET / AI FOR THIS, I was past the point of caring, the problem is not something I care to solve right now.
init([]) ->
    SupFlags = {simple_one_for_one, 1, 5},
    ChildSpec = {
        undefined,
        {gen_worker, start_link, []},
        temporary,
        5000,
        worker,
        [gen_worker]
    },
    {ok, {SupFlags, [ChildSpec]}}.