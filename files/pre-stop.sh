#!/bin/bash

run_nodetool() {
  echo "Running: nodetool $1"
  nodetool $1
  sleep 5
}

while [ $(nodetool status | awk "/$CASSANDRA_RACK/{ print \$1,\$2 }" | grep -v $POD_IP | awk '{ print $1 }' | grep -v UN) -eq 0 ] ; do
  echo "Waiting all nodes to recover a correct status before draining this node"
  sleep 5
  pidof java || exit 1
done

run_nodetool disablethrift
run_nodetool disablebinary
run_nodetool disablegossip
run_nodetool flush
run_nodetool drain
sleep 10
run_nodetool stop
run_nodetool stopdaemon

exit 0
