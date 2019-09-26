-module(arrebol_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    ApiSpec = {
        arrebol_api_sup,
        {arrebol_api_sup, start_link, []},
        permanent,
        5000,
        supervisor,
        [arrebol_api_sup]},
    SchedulerSpec = {
        scheduler_sup,
        {scheduler_sup, start_link, []},
        permanent,
        5000,
        supervisor,
        [scheduler_sup]},
    {ok, { {one_for_one, 5, 10}, [ApiSpec, SchedulerSpec]} }.

%% internal functions
