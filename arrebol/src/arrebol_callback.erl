-module(arrebol_callback).
-export([handle/2, handle_event/3]).

-include_lib("elli/include/elli.hrl").
-behaviour(elli_handler).

handle(Req, _Args) ->
    %% Delegate to our handler function
    handle(Req#req.method, elli_request:path(Req), Req).

handle('GET', [<<"job">>, Id], _Req) ->
    io:format("Result ~p~n", [Id]),
    io:format("req ~p~n", [_Req]),
    {ok, [], <<"Hi">>};

handle('POST', [<<"job">>], _Req) ->
	io:format("req ~p~n", [_Req]),
	Job = elli_request:body(_Req),
	{scheduler, 'scheduler@raoni-Inspiron-5548'} ! {add, binary_to_list(Job), {?MODULE, node()}},
	{ok,[]};

handle('GET',[<<"hello">>, <<"world">>], _Req) ->
    %% Reply with a normal response. 'ok' can be used instead of '200'
    %% to signal success.
    {ok, [], <<"Hello World!">>};

handle(_, _, _Req) ->
    {404, [], <<"Not Found">>}.

%% @doc: Handle request events, like request completed, exception
%% thrown, client timeout, etc. Must return 'ok'.
handle_event(_Event, _Data, _Args) ->
    ok.
