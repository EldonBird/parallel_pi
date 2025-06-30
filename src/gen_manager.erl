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

terminate(_Reason, _State) ->
    ok.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

run_calculation(PointsPerWorker, WorkerNum) ->
    gen_server:call(?MODULE, {run, PointsPerWorker, WorkerNum}).


% State = {[Workers], {Total, Inside}}.

start_worker() ->
    {ok, Pid} = supervisor:start_child(gen_sup, []),
    Pid.

handle_cast({long, Digits, NumWorkers}, State) ->

    Workers = [start_worker() || _ <- lists:seq(1, NumWorkers)],
    
    
    {noreply, State};

handle_cast({result, {Running_Total, Running_Inside}}, State) ->
    {Workers, {Global_Total, Global_Inside}} = State,

    {noreply, {Workers, {Global_Total + Running_Total, Global_Inside + Running_Inside}}}.



handle_call({run, PointsPerWorker, NumWorkers}, _From, State) ->
    Workers = [start_worker() || _ <- lists:seq(1, NumWorkers)],

    give_work(Workers, PointsPerWorker, 0),

    Total = get_work(Workers, []),

    Estimate = calculate_pi(Total, PointsPerWorker * NumWorkers),


    {reply, Estimate, State};
handle_call({get}, _From, State) ->
    {_, Result} = State,
    {reply, State, State}.







give_long_work([]) ->
    ok;
give_long_work([Head | Tail]) ->
    MyOwnPID = self(),
    gen_server:cast(Head, {long, MyOwnPID}),
    give_long_work(Tail).




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



calculate_pi(_, 0) ->
    0;
calculate_pi(Inside_Count, Total) ->
    Inside_Total = lists:sum(Inside_Count),
    4 * Inside_Total / Total.

