#!/bin/bash
REPY_PATH=~/tools/demokit/
CODE=$REPY_PATH/code
count=100
runnumber=2

cd $REPY_PATH

function run_test
{
  dgram=$1
  rtries=$2
  tout=$3
  time_to_wait=$(echo $count*$tout/1000 + 60 | bc)
  
  dd if=/dev/zero of=$CODE/$in_file bs=$dgram count=$count 
  # init
  rm $CODE/test_out*
  cmd on %all reset
  cmd on %all stop

  # run
  cmd on %2 upload $CODE/$in_file $in_file 
  cmd on %1 run $CODE/server.repy $out_file $client_port 
  cmd on %2 run $CODE/client.repy $in_file $server_ip $server_port $client_ip $client_port $dgram $rtries $tout
  sleep $time_to_wait
  cmd on %1 show log
  cmd on %2 show log
  cmd on %1 download $out_file $CODE/$out_file

  while ! file $CODE/$out_file* &> /dev/null
  do
    echo -n .
    sleep 1 
  done

  before=1
  after=0
  while [ $before -ne $after ]
  do
    after=$(ls -l $CODE/$out_file*|awk '{print $5}')
    sleep 3
    before=$(ls -l $CODE/$out_file*|awk '{print $5}')
    echo Waiting to be the same: 'before='$before 'after='$after
  done

  # evaluate
  echo -e "\n"
  trans_dgrams=$( echo $(cat $CODE/$out_file* | wc -c) / $dgram | bc )
  echo Transmitted datagrams: $trans_dgrams/$count 'tout='$tout 'rtries='$rtries 'dgram='$dgram | tee -a $CODE/Measurement1.log

  cp $CODE/$out_file* $CODE/out_${dgram}_${rtries}_${tout}_${runnumber}
  cp $CODE/$in_file $CODE/in_${dgram}_${rtries}_${tout}_${runnumber}


  cmd on %all reset
  cmd on %all stop
  sleep 3
}

function get_ip
{
  cmd on $1 list | egrep "^[[:space:]]*$1" |  awk '{print $2}' | cut -d: -f1
}

user='lorcs1'
in_file='test_in'
out_file='test_out'

server_ip='128.84.154.45' # %1
#server_ip=$(get_ip %1) # %1
server_port='63177'
client_ip='141.212.113.180' # $2
#client_ip=$(get_ip %2) # $2
client_port='63177'

if [ -z "$server_ip" ] || [ -z "$client_ip" ]; then
  # TODO: and they not equal
  echo "Failed to get either server or client ip"
  exit  1
fi

function cmd
{
  echo -e "\033[32m\n$*\033[00m"
  echo $* > /proc/$seash_pid/fd/0
  sleep 3
}

function setup
{
  #kill -9 `ps aux | grep 'python seash.py'| grep -v grep| awk '{print $2}'`
  (while [ 1 ]; do sleep 1; done) | python seash.py &
  seash_pid=$!
  sleep 1
  cmd loadkeys $user
  cmd as $user
  cmd browse
}

function teardown
{
  cmd exit
  exit 1
}

setup

#run_test 1000 0 8192| egrep "Success with|Failure with"
#alias check='grep "Transmitted byte"'
#run_test 512  0 0
#run_test 8192 0 0     
#run_test 512  0 500   
#run_test 8192 0 500   
#run_test 512  0 1000  
#run_test 8192 0 1000  
#run_test 512  0 2000  
#run_test 8192 0 2000  

run_test 100   10000 10  
#run_test 512  20 10  
#run_test 2048 20 10  
#run_test 8192 20 10  

#run_test 10   20 50  
#run_test 512  20 50  
#run_test 2048 20 50  
#run_test 8192 20 50  

#run_test 10   20 500  
#run_test 512  20 500  
#run_test 2048 20 500  
#run_test 8192 20 500  

teardown
