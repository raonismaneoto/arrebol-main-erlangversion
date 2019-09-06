-module(worker).

-export([start/1, loop/1]).

start(Env) ->
	subs(Env),
	register(?MODULE, spawn(?MODULE, loop, [Env])).

subs({Scheduler}) -> 
	Scheduler ! {subs, node()}.

loop({Scheduler}) -> 
	Scheduler ! {schedule, {?MODULE, node()}},
	receive
		{schedule, Job, From} ->
			execute_job(Job),
			loop({Scheduler});
		{schedule, empty} ->
			loop({Scheduler})
	end.

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
