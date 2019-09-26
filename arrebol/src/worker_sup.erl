-module(worker_sup).

-behaviour(supervisor).

-export([start_link/1]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link(Scheduler) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, [Scheduler]).

init([Scheduler]) ->
    Spec = {
        worker_sup,
        {worker, start, [Scheduler]},
        permanent,
        5000,
        worker,
        [worker]},
    {ok, { {one_for_one, 5, 10}, [Spec]} }.
