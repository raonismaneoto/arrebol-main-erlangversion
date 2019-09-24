%%%-------------------------------------------------------------------
%% @doc arrebol public API
%% @end
%%%-------------------------------------------------------------------

-module(arrebol_app).

-behaviour(application).

-export([start/0, start/2, stop/1]).

start() ->
	application:start(arrebol).

start(_StartType, _StartArgs) ->
    arrebol_sup:start_link(),
    scheduler_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
