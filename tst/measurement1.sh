#!/bin/bash
REPY_PATH=~/tools/demokit/

function run_test
{
  tout=$1
  rtries=$2
  dgram=$3
  (
  echo loadkeys $user; 
  echo as $user;
  echo browse;
  echo on %1 reset;
  echo on %2 reset;
  echo on %1 run code/server.repy $out_file $client_port
  echo on %2 upload code/$in_file $in_file
  echo on %2 run code/client.repy $in_file $server_ip $server_port $client_ip $client_port $dgram $rtries $tout;
  echo on %1 show log;
  echo on %2 show log;
  echo on %1 download $out_file code/$out_file
  echo exit;
  )| python seash.py

  echo -e"\n"
  if diff code/test_in code/test_out*; then
    echo Success with: 'tout='$tout 'rtries='$rtries 'dgram='$dgram
  else
    echo Failure with: 'tout='$tout 'rtries='$rtries 'dgram='$dgram
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
rm code/test_out*

run_test 1000 4 512

