APP_ROOT=/user/$1
BLOCK_SIZE_VALUE=$2;                                                                                               
FILE_URL=http://bulk.openweathermap.org/sample/;                                                                      
files_array=(city.list city.list.min current.city current.city daily_14 daily_16 history.city.list history.city.list.min hourly_14 hourly_16 weather_14 weather_16);
RES_DIR=$APP_ROOT/res;                                                                                                
CURRENT_DIR=$(pwd);                                                                                                   
TEMP_DIR="$CURRENT_DIR"/temp;                                                                                         
hdfs dfs -mkdir $APP_ROOT;                                                                                            
hdfs dfs -mkdir $RES_DIR;                                                                                             
mkdir $TEMP_DIR;                                                                                                      
declare -A file_names_array;                                                                                          
for i in "${files_array[@]}";                                                                                         
do                                                                                                                    
file_base_name="$i".json.gz;                                                                                          
file_name=$RES_DIR/"$i".json;                                                                                         
echo $file_name;                                                                                                      
wget -O $TEMP_DIR/$file_base_name "${FILE_URL}${file_base_name}";                                                     
gunzip $TEMP_DIR/$file_base_name;                                                                                     
hdfs dfs -D dfs.blockSize=$BLOCK_SIZE_VALUE -put $TEMP_DIR/"$i".json $file_name;                                      
done;                                                                                                                 
sleep 5;                                                                                                              
clear;                                                                                                                
hdfs dfs -ls -R $APP_ROOT;                                                                                            
sleep 10;                                                                                                             
hdfs fsck $RES_DIR -files -blocks;                                                                                    
sleep 10;                                                                                                             
clear;                                                                                                                
rm -rf $TEMP_DIR;    