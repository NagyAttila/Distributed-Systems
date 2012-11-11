REPY_PATH=~/tools/demokit/

dir_ori=$(pwd)
cd $(dirname $(pwd)/$0) || exit 1
rm -r compile
mkdir compile &&
cp -rv src/* compile

cd compile

python ${REPY_PATH}/repypp.py reliable_server.repy server.repy
python ${REPY_PATH}/repypp.py reliable_client.repy client.repy

cd ../tst
python ${REPY_PATH}/repypp.py reliable.repy test_reliable.repy

#cp client.repy server.repy ..

echo To run client
echo python ${REPY_PATH}/repy.py compile/restrictions.test compile/client.repy 
echo To run server
echo python ${REPY_PATH}/repy.py compile/restrictions.test compile/server.repy 
echo To run api tests
echo python ${REPY_PATH}/repy.py compile/restrictions.test tst/test_reliable.repy

exit
