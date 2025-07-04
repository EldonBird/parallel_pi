%%%-------------------------------------------------------------------
%%% @author Birdh
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Jun 2025 22:19
%%%-------------------------------------------------------------------
-module(gen_manager).
-behavior(gen_server).
-author("Birdh").

%% API
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    terminate/2,
    start_link/0,
    run/1
]).


% State = {Workers[], {Total, Inside}} ......

init([]) ->
    {ok, []}.

terminate(_Reason, _State) ->
    ok.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

run(NumberWorkers) ->
    gen_server:cast(?MODULE, {run, NumberWorkers}).


handle_cast({mc, Number}, _) ->
    Workers = [start_worker_mc() || _ <- lists:seq(1, Number)], 
    assign_work_mc(Workers, 1),
    {noreply, {Workers, {0, 0}}};

handle_cast({agm, Number}, _) ->
    Workers = [start_worker_agm() || _ <- lists:seq(1, Number)],
    assign_work(Workers, 1),
    {noreply, {Workers, {0, 0}}};

handle_cast({result_mc, Result}, State) ->
    {Workers, {Previous_Total, Previous_Inside}} = State,
    {Running_Total, Running_Inside} = Result,
    New_Total = Previous_Total + Running_Total,
    New_Inside = Previous_Inside + Running_Inside,
    {noreply, {Workers, {New_Total, New_Inside}}};

handle_cast({result_agm, Result}, State) ->
    {Pi, Iter} = Result,
    {Workers, {_, _}} = State,
    {noreply, {Workers, {Pi, Iter}}}.




handle_call({get_mc}, _From, State) ->
    {_, {Total, Inside}} = State,
    Result = calculate_pi(Total, Inside),
    {reply, Result, State};
handle_call({get_agm}, _From, State) ->
    {_, {Pi, Itter}} = State,
    {reply, {Pi, Itter}, State}.
    

start_worker_mc() ->
  {ok, Pid} = supervisor:start_child(sup_worker_long, []),
  Pid.

start_worker_agm() ->
    {ok, Pid} = supervisor:start_child(sup_worker_agm, []),
    Pid.



% Monte Carlo

assign_work_mc([], _) ->
    ok;
assign_work_mc([Head | Tail], Offset) ->
    gen_server:cast(Head, {long, self(), Offset}),
    assign_work(Tail, Offset+1).


calculate_pi(_, 0) ->
    0;
calculate_pi(Total, Inside) ->
    4 * Inside / Total.



% Algorithmic Geometric Mean

% This tells it to perform 1 iteration 
assign_work_agm([]) ->
    ok;
assign_work_agm([Head|Tail]) ->
    gen_server:cast(Head, {iteration}),
    assign_work_agm(Tail).
    





