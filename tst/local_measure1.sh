#!/bin/bash
REPY_PATH=~/tools/demokit/

cd $(dirname $0)

cp ../compile/restrictions.test ../compile/{client,server}.repy .


function run_test
{
  killall python
  rm test_out

  dgram=$1
  rtries=$2
  tout=$3
  servertout=$( echo $dgram\*$count/10000 + 10 | bc )
  dd if=/dev/urandom of=$in_file bs=$dgram count=$count 
  python $REPY_PATH/repy.py restrictions.test server.repy $out_file $server_port $servertout&
  sleep 1
  python $REPY_PATH/repy.py restrictions.test client.repy $in_file $server_ip $server_port $client_ip $client_port $dgram $rtries $tout

  trans_dgrams=$( echo $(cat $out_file* | wc -c) / $dgram | bc )
  echo Transmitted datagrams: $trans_dgrams/$count 'tout='$tout 'rtries='$rtries 'dgram='$dgram | tee -a $0.log
}
count=10
server_ip='127.0.0.1'
server_port=12345
client_ip='127.0.0.1'
client_port=12346
in_file='test_in'
out_file='test_out'

run_test 512  0 0
run_test 8192 0 0     
run_test 512  0 500   
run_test 8192 0 500   
run_test 512  0 1000  
run_test 8192 0 1000  
run_test 512  0 2000  
run_test 8192 0 2000  

