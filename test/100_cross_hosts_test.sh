#! /bin/bash

. ./config.sh

C1=10.2.1.4
C2=10.2.1.7

start_suite "Ping over cross-host weave network"

for HOST in $HOST1 $HOST2; do
    weave_on $HOST stop || true
    weave_on $HOST stop-dns || true
    docker_on $HOST rm -f c1 c2 || true
done

weave_on $HOST1 launch
weave_on $HOST2 launch $HOST1

weave_on $HOST2 run $C2/24 -t --name=c2 ubuntu
weave_on $HOST1 run $C1/24 -t --name=c1 ubuntu
assert_raises "exec_on $HOST1 c1 ping -q -c 4 $C2"

end_suite
