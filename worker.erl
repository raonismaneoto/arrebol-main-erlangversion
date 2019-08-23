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

execute_job(Job) ->
	io:format("executing...").
