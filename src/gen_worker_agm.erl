%%%-------------------------------------------------------------------
%%% @author Birdh
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Jul 2025 12:44
%%%-------------------------------------------------------------------
-module(gen_worker_agm).
-behavior(gen_server).
-author("Birdh").

%% API
-export([handle_call/3, handle_cast/2, terminate/2, init/1, start_link/0]).


% State = {An, Bn, Pn, Tn, n}
init([]) ->
    {ok, {1, 1/math:sqrt(2), 1, 1/4, 0}}.

start_link() ->
    gen_server:start_link(?MODULE, [], []).

terminate(_Reason, _State) -> ok.


handle_cast({iteration, ManagerPid, Iterations}, {An, Bn, Pn, Tn, N}) when N < Iterations ->
    
    An1 = an(An, Bn),
    Bn1 = bn(An, Bn),
    Pn1 = pn(Pn),
    Tn1 = tn(Tn, Pn, An, An1),
    
    Pi = pi(An1, Bn1, Tn1),
    
    gen_server:cast(ManagerPid, {result_agm, {Pi, N+1}}),
    gen_server:cast(self(), {iteration, ManagerPid, Iterations}),

    {noreply, {An1, Bn1, Pn1, Tn1, N+1}};
handle_cast({iteration, ManagerPid, _}, State) ->

    {An, Bn, _, Tn, N} = State,
    Pi = pi(An, Bn, Tn),
    gen_server:cast(ManagerPid, {result_agm, {Pi, N}}),
    {noreply, State}.



handle_call({get}, _From, State) ->

    {An, Bn, _, Tn, N} = State,
    Pi = pi(An, Bn, Tn),
    {reply, {Pi, N}, State}.


an(An, Bn) ->
    (An + Bn) / 2.

bn(An, Bn) ->
    math:sqrt(An * Bn).

pn(Pn) ->
    2 * Pn.

tn(Tn, Pn, An, An1) ->
    
    By = An1 - An,
    
    Tn - Pn * (By * By).

pi(An1, Bn1, Tn1) ->
    
    By = An1 + Bn1,

    (By * By) / (4 * Tn1).

