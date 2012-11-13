#!/bin/bash
REPY_PATH=~/tools/demokit/

cd $(dirname $0)

cp ../compile/restrictions.test ../compile/{client,server}.repy .
rm test_out

python $REPY_PATH/repy.py restrictions.test server.repy test_out 12346 &

sleep 1

python $REPY_PATH/repy.py restrictions.test client.repy test_in 127.0.0.1 12346 127.0.0.1 12345 512 5 1000

if diff test_in test_out; then
  echo !!!SUCCESSFUL!!!
else
  echo !!!FAILED!!!
fi

