-module(arrebol_worker).
-export([start_link/1, loop/1]).
-callback(execute_job(_) -> ok).
-callback(start(_) -> ok).

start_link({Scheduler, Module, Node}) ->
	subs(Scheduler, Module, Node),
	register(?MODULE, spawn(?MODULE, loop, [{Scheduler, Module, Node}])).

subs(Scheduler, Module, Node) ->
    rpc:call(Scheduler, scheduler, subs, [{Module, Node}]),
    ok.

loop({Scheduler, Module, Node}) ->
    Answer = rpc:call(Scheduler, scheduler,schedule, []),
	case Answer of
		{schedule, Job, From} ->
			io:format("received"),
			Module:execute_job(Job),
			loop({Scheduler, Module, Node});
		{schedule, empty} ->
			io:format("received"),
			loop({Scheduler, Module, Node})
	end.
