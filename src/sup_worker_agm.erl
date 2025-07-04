%%%-------------------------------------------------------------------
%%% @author Birdh
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Jun 2025 22:20
%%%-------------------------------------------------------------------
-module(sup_worker_agm).
-author("Birdh").
-behavior(supervisor).


%% API
-export([start_link/0, init/1]).


start_link() -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).



% I am a bit puzzled as to why this works but not what I was doing before or in the others...
init([]) ->
    SupFlags = {simple_one_for_one, 1, 5},
    ChildSpec = {
        undefined,
        {gen_worker_agm, start_link, []},
        temporary,
        5000,
        worker,
        [gen_worker_agm]
    },
    {ok, {SupFlags, [ChildSpec]}}.