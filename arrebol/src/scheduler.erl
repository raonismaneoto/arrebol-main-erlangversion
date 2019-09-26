-module(scheduler).
-behaviour(gen_server).
-export([start/1, init/1, handle_call/3, handle_cast/2, subs/1, schedule/0, add/1]).

init(Env) ->
	{ok, Env}.

start(Env) ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, Env, []).

subs(Node) ->
	gen_server:call(?MODULE, {subs, Node}).

schedule() ->
	gen_server:call(?MODULE, {schedule}).

add(Job) ->
	gen_server:cast(?MODULE, {add, Job}).

handle_call({subs, Node}, _From, {[], []}) ->
	{reply, ok, {[], [Node]}};

handle_call({schedule}, _From, {[], []}) ->
	{reply, {schedule, empty}, {[], []}};

handle_call({subs, Node}, _From, {[Head | Tail], []}) ->
	{reply, ok, {[Head | Tail], [Node]}};

handle_call({schedule}, _From, {[], [Head | Tail]}) ->
	io:format("received schedule msg"),
	{reply, {schedule, empty}, {[], [Head | Tail]}};

handle_call({subs, Node}, _From, {[], [Head | Tail]}) ->
	{reply, ok, {[], [Head, lists:append(Tail, [Node])]}};

handle_call({schedule}, _From, {[Head | Tail], [Whead | Wtail]}) ->
	io:format("received schedule msg"),
	{reply, {schedule, Head, self()}, {Tail, [Whead | Wtail]}};

handle_call({subs, Node}, _From, {[Head | Tail], [Whead | Wtail]}) ->
	{reply, ok, {[Head | Tail], [Head, lists:append(Tail, [Node])]}}.

handle_cast({add, Job}, {[], []}) ->
	{noreply, {[Job], []}};

handle_cast({add, Job}, {[Head | Tail], []}) ->
	{noreply, {[Head | lists:append(Tail, [Job])], []}};

handle_cast({add, Job}, {[], [Head | Tail]}) ->
	{noreply, {[Job], [Head | Tail]}};

handle_cast({add, Job}, {[Head | Tail], [Whead | Wtail]}) ->
	{noreply, {[Head | lists:append(Tail, [Job])], [Whead | Wtail]}}.