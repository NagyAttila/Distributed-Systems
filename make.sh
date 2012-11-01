REPY_PATH=~/tools/seattle/seattle_repy/

dir_ori=$(pwd)
cd $(dirname $(pwd)/$0) || exit 1
rm -r compile
mkdir compile &&
cp -rv src/* compile

cd compile

python ${REPY_PATH}/repypp.py reliable_server.repy server.repy
python ${REPY_PATH}/repypp.py reliable_client.repy client.repy

#cp client.repy server.repy ..

echo To run client
echo python ${REPY_PATH}/repy.py compile/restrictions.test compile/client.repy 
echo To run server
echo python ${REPY_PATH}/repy.py compile/restrictions.test compile/server.repy 

exit
