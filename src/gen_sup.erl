%%%-------------------------------------------------------------------
%%% @author Eldon
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Jun 2025 19:16
%%%-------------------------------------------------------------------
-module(gen_sup).
-author("Eldon").
-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {
        ok,
        {
            {one_for_one, 10, 10},
            [
                {gen_manager,
                    {gen_manager, start_link, []},
                    permanent,
                    5000,
                    worker,
                    [gen_manager]},

                {gen_worker,
                    {gen_worker, start_link, []},
                    temporary,
                    5000,
                    worker,
                    [gen_worker]}
            ]
        }
    }.