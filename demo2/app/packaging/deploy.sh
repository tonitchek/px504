app_name=PX504_BLOCKCHAIN_APP

rm -rf $app_name $app_name.zip

mkdir $app_name

mkdir $app_name/app
cp ../../src/* $app_name/app
cp content.txt $app_name
cp *.json  $app_name
cp geth.exe $app_name
cp password $app_name
cp setup.bat $app_name

zip -r $app_name.zip $app_name
