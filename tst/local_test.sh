#!/bin/bash
REPY_PATH=~/tools/demokit/

count=20
server_ip='127.0.0.1'
server_port=12345
client_ip='127.0.0.1'
client_port=12346
in_file='test_in'
out_file='test_out'
dgram=512

dgram=512
tout=1000
rtries=5

cd $(dirname $0)

cp ../compile/restrictions.test ../compile/{client,server}.repy .
rm test_out

killall ptython


dd if=/dev/urandom of=$in_file bs=$dgram count=$count 
servertout=$( echo $dgram\*$count/10000 + 10 | bc )

python $REPY_PATH/repy.py restrictions.test server.repy $out_file $server_port &
python $REPY_PATH/repy.py restrictions.test client.repy $in_file $server_ip $server_port $client_ip $client_port $dgram $rtries $tout


if diff test_in test_out; then
  echo !!!SUCCESSFUL!!!
else
  echo !!!FAILED!!!
fi

