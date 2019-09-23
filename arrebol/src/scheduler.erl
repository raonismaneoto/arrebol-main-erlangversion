-module(scheduler).

-export([start/1, loop/1]).

start(Env) ->
	register(?MODULE, spawn(?MODULE, loop, [Env])).

loop({[], []}) ->
	receive
		{subs, Node} ->
			loop({[], [Node]});
		{add, Job, From} ->
			io:format("Job ~p~n", [Job]),
			loop({[Job], []});
		{schedule, From} ->
			From ! {schedule, empty},
			loop({[], []})
	end;
loop({[Head | Tail], []}) ->
	receive
		{subs, Node} ->
			loop({[Head | Tail], [Node]});
		{add, Job, From} ->
			loop({[Head | lists:append(Tail, [Job])], []})
	end;
loop({[], [Head | Tail]}) ->
	receive
		{shedule, From} ->
			From ! {schedule, empty},
			loop({[], [Head | Tail]});
		{add, Job, From} ->
			loop({[Job], [Head | Tail]});
		{subs, Node} ->
			loop({[], [Head, lists:append(Tail, [Node])]})
	end;
loop({[Head | Tail], [Whead | Wtail]}) ->
	receive
		{add, Job, From} ->
			loop({[Head | lists:append(Tail, [Job])], [Whead | Wtail]});
		{schedule, From} ->
			schedule_job(Head, From),
			loop({Tail, [Whead | Wtail]});
		{subs, Node} ->
			loop({[Head | Tail], [Whead | Wtail]})
	end.

schedule_job(Job, From) ->
	io:format("From ~p~n", [From]),
	io:format("Job ~p~n", [Job]),
	From ! {schedule, Job, self()},
	ok.