#!/bin/bash

cd arrebol
rebar get-deps
rebar compile
erl -detached -pa deps/*/ebin ebin -s arrebol_app start
exit 0
