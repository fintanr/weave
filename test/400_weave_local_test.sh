#!/bin/bash

. ./config.sh

start_suite "Run weave with --local"

run_on $HOST1 sudo ./weave --local reset

run_on $HOST1 sudo ./weave --local launch
assert_raises "docker_on $HOST1 ps | grep weave" 0

docker_on $HOST1 rm -f c1 || true
run_on $HOST1 sudo ./weave --local run 10.2.6.5/24 -ti --name=c1 ubuntu
ok=$(exec_on $HOST1 c1 ifconfig | grep ethwe)
assert "test -n \"$ok\" && echo pass" "pass"

docker_on $HOST1 rm -f c1 || true

end_suite
