#!/bin/sh -e

#This should be switched to core master once artifacts will be available on master
ref='issue-403'
project='a.czyzewska'
# project='eyeo%2Fadblockplus%2Fabc'

#Fetching Historical Data
current_pipeline_id=$(curl -sS -H "Content-Type: application/json" \
                              'https://gitlab.com/api/v4/projects/'$project'%2Fadblockpluscore/pipelines?per_page=200' | \
                          jq -r \
                             'map(select(.ref=="'$ref'" and .status=="success")) | first | .id')
current_job_id=$(curl -sS -H "Content-Type: application/json" \
                           'https://gitlab.com/api/v4/projects/'$project'%2Fadblockpluscore/pipelines/'$current_pipeline_id'/jobs' | \
                     jq -r \
                        'map(select(.ref=="'$ref'" and .name=="benchmark")) | first | .id')
fetch_dir=$PWD/benchmark
test -d $fetch_dir || mkdir $fetch_dir
curl -sS -L \
       --output $fetch_dir/artifacts.zip \
      'https://gitlab.com/api/v4/projects/'$project'%2Fadblockpluscore/jobs/'$current_job_id'/artifacts'

#Creating temporary folder for artifacts to not override current one
mkdir benchmark/historicalData
unzip $fetch_dir/artifacts.zip -d benchmark/historicalData
rm -rf benchmark/artifacts.zip
echo 'Historical Data extracted to benchmark folder'

#Extracting current benchmark data and adding to historical data
echo 'Data for timestamp '$1' will be added to historical Data'
node benchmark/extendHistoricalData.js --ts=$1
#rm -rf benchmark/historicalData