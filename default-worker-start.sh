#!/bin/bash
node=$1
erl -sname worker << EOF
  c(worker).
  worker:start({{scheduler, '$node'}})
