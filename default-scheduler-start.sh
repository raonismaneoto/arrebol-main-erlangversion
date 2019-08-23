#!/bin/bash

erl -sname scheduler << EOF
  c(scheduler).
  scheduler:start({[], []}).
EOF
