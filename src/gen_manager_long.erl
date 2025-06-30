%%%-------------------------------------------------------------------
%%% @author Birdh
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Jun 2025 22:19
%%%-------------------------------------------------------------------
-module(gen_manager_long).
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


handle_cast({run, Number}, State) ->
    Workers = [start_worker() || _ <- lists:seq(1, Number)], 
    assign_work(Workers),
    {noreply, {Workers, {0, 0}}};
handle_cast({result, Result}, State) ->
    {Workers, {Previous_Total, Previous_Inside}} = State,
    {Running_Total, Running_Inside} = Result,
    New_Total = Previous_Total + Running_Total,
    New_Inside = Previous_Inside + Running_Inside,
    {noreply, {Workers, {New_Total, New_Inside}}}.


handle_call({get}, _From, State) ->
    {_, {Total, Inside}} = State,
    Result = calculate_pi(Total, Inside),
    {reply, Result, State}.
    
    

start_worker() ->
  {ok, Pid} = supervisor:start_child(sup_worker_long, []),
  Pid.


assign_work([]) ->
    ok;
assign_work([Head | Tail]) ->
    gen_server:cast(Head, {long, self()}),
    assign_work(Tail).


calculate_pi(_, 0) ->
    0;
calculate_pi(Total, Inside) ->
    Inside_Total = lists:sum(Inside),
    4 * Inside_Total / Total.


