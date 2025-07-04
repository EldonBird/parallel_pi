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
-export([]).


% State = {An, Bn, Pn, Tn, n}
init([]) ->
    {ok, {1, 1/sqrt(2), 1, 1/4, 0}}.

start_link() ->
    gen_server:start_link(?MODULE, [], []).

terminate(_Reason, _State) -> ok.


handle_cast({iteration}, State) ->

    {An, Bn, Pn, Tn, N} = State,
    
    An1 = an(An, Bn),
    Bn1 = bn(An, Bn),
    Pn1 = pn(Pn),
    Tn1 = tn(Tn, Pn, An, An1),

    {noreply, {An1, Bn1, Pn1, Tn1, N+1}}.
    
handle_call({get}, State) ->

    {An, Bn, _, Tn, N} = State,
    Pi = pi(An, Bn, Tn),
    {reply, {Pi, N}, State}.


an(An, Bn) ->
    (An + Bn) / 2.

bn(An, Bn) ->
    sqrt(An * Bn, 2).

pn(Pn) ->
    2 * Pn.

tn(Tn, Pn, An, An1) ->
    Tn - Pn * pow((An1 - An), 2).

pi(An1, Bn1, Tn1) ->
    pow((An1 + Bn1), 2) / (4 * Tn1).