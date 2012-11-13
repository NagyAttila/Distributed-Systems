#!/bin/bash
REPY_PATH=~/tools/demokit/
CODE=$REPY_PATH/code

function run_test
{
  tout=$1
  rtries=$2
  dgram=$3
  (
  # init
  rm $CODE/test_out*
  echo loadkeys $user; 
  echo as $user;
  echo browse;
  echo on %1 reset;
  echo on %2 reset;

  # run
  echo on %1 run $CODE/server.repy $out_file $client_port
  echo on %2 upload $CODE/$in_file $in_file
  echo on %2 run $CODE/client.repy $in_file $server_ip $server_port $client_ip $client_port $dgram $rtries $tout;
  echo on %1 show log;
  echo on %2 show log;
  echo on %1 download $out_file $CODE/$out_file
  echo exit;
  )| python seash.py

  # evaluate
  echo -e"\n"
  if diff $CODE/test_in $CODE/test_out*; then
    echo Success with: 'tout='$tout 'rtries='$rtries 'dgram='$dgram
  else
    echo Failure with: 'tout='$tout 'rtries='$rtries 'dgram='$dgram
    echo Transmitted bytes: $(cat $CODE/$out_file* | wc -c)/$(cat $CODE/$in_file | wc -c)
  fi
}


user='lorcs1'
in_file='test_in'
out_file='test_out'

server_ip='203.159.127.2' 
server_port='63177'
client_ip='203.159.127.3'
client_port='63177'

cd $REPY_PATH

# to see only the results extend the commands with 
# '| egrep "Success with|Failure with"'
run_test 1000 0 512 
run_test 1000 0 8192

