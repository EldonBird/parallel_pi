%%%-------------------------------------------------------------------
%%% @author Birdh
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Jun 2025 22:20
%%%-------------------------------------------------------------------
-module(sup_manager).
-behavior(supervisor).
-author("Birdh").

%% API
-export([start_link/0, init/1]).


start_link() -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {
        ok,
        {{one_for_one, 1, 60},
            [
                {gen_manager, {gen_manager, start_link, []},
                    permanent,
                    5000,
                    worker,
                    [gen_manager]},
                {sup_worker_mc, {sup_worker_mc, start_link, []},
                    permanent,
                    5000,
                    supervisor,
                    [sup_worker_mc]},
                {sup_worker_agm, {sup_worker_agm, start_link, []},
                    permanent,
                    5000,
                    supervisor,
                    [sup_worker_agm]}
                
            ]
        }
    }.