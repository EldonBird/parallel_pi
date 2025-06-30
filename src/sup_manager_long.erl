%%%-------------------------------------------------------------------
%%% @author Birdh
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Jun 2025 22:20
%%%-------------------------------------------------------------------
-module(sup_manager_long).
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
                {gen_manager_long, {gen_manager_long, start_link, []},
                    permanent,
                    5000,
                    worker,
                    [gen_manager_long]},
                {sup_worker_long, {sup_worker_long, start_link, []},
                    permanent,
                    5000,
                    supervisor,
                    [sup_worker_long]}
            ]
        }
    }.