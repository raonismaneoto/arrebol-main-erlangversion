-module(worker).
-behaviour(arrebol_worker).
-export([start/1, execute_job/1]).

init(Env) ->
    {ok, Env}.
    
start(Env) ->
    arrebol_worker:start_link({Env, ?MODULE, node()}).

execute_job(Command) ->
    Port = open_port({spawn, Command}, [stream, in, eof, hide, exit_status]),
    Result = get_data(Port, []),
    io:format("Result ~p~n", [Result]),
    Result.

get_data(Port, Sofar) ->
    receive
    {Port, {data, Bytes}} ->
        get_data(Port, [Sofar|Bytes]);
    {Port, eof} ->
        Port ! {self(), close},
        receive
        {Port, closed} ->
            true
        end,
        receive
        {'EXIT',  Port,  _} ->
            ok
        after 1 ->              % force context switch
            ok
        end,
        ExitCode =
            receive
            {Port, {exit_status, Code}} ->
                Code
        end,
        {ExitCode, lists:flatten(Sofar)}
    end.
