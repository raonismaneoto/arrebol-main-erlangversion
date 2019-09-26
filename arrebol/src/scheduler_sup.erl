-module(scheduler_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).


init([]) ->
	Opts = {[], []},
    Spec = {
        scheduler_sup,
        {scheduler, start, [Opts]},
        permanent,
        5000,
        worker,
        [scheduler]},
    {ok, { {one_for_one, 5, 10}, [Spec]} }.
