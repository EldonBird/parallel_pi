%%%-------------------------------------------------------------------
%%% @author Eldon
%%% @copyright (C) 2025, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Jun 2025 19:16
%%%-------------------------------------------------------------------
-module(gen_manager).
-author("Eldon").
-behavior(gen_server).

%% API
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    start_link/0,
    run_calculation/2
]).

init([]) ->
    {ok, []}.

terminate() ->
    {ok, []}.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

run_calculation(PointsPerWorker, WorkerNum) ->
    gen_server:call(?MODULE, {run, PointsPerWorker, WorkerNum}).



start_worker() ->
    {ok, Pid} = supervisor:start_child(gen_sup, []),
    Pid.

handle_cast(_, State) ->
    {noreply, State}.


handle_call({run, PointsPerWorker, NumWorkers}, _From, State) ->
    Workers = [start_worker() || _ <- lists:seq(1, NumWorkers)],

    give_work(Workers, PointsPerWorker, 0),

    Total = get_work(Workers, []),

    Estimate = calculate_pi(Total, PointsPerWorker * NumWorkers),


    {reply, Estimate, State}.








give_work([], _, _) ->
    ok;
give_work([Head | Tail], Amount, Starting_Point) ->
    gen_server:cast(Head, {calculate, Starting_Point, Starting_Point + Amount}),
    give_work(Tail, Amount, Starting_Point + Amount).


get_work([], Result) ->
    Result;
get_work([Head | Tail], Result) ->
    {_, Inside} = gen_server:call(Head, {last}),
    get_work(Tail, [Inside | Result]).


calculate_pi(Inside_Count, Total) ->
    Inside_Total = lists:sum(Inside_Count),
    4 * Inside_Total / Total.

