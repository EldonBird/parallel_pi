%%%-------------------------------------------------------------------
%%% @author eldon
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Jun 2025 10:59 PM
%%%-------------------------------------------------------------------
-module(man_sup).
-author("eldon").
%%% manager_sup.erl
-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link() -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).
init([]) ->
  {ok,
    {{one_for_one, 1, 5},
      [{gen_manager,
        {gen_manager, start_link, []},
        permanent,
        5000,
        worker,
        [gen_manager]},

        {gen_sup,
          {gen_sup,     start_link, []},
          permanent,
          5000,
          supervisor,
          [gen_sup]}
      
      ]
    }
  
  
  }.
