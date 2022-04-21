#!/bin/bash
#git clone https://gitlab.com/eyeo/adblockplus/abc/adblockpluscore.git
cd adblockpluscore
rm -rf benchmark/benchmarkresults.json
npm install 
#npm run benchmark:save
CURRENTTS=$(date +%FT%TZ)
FLAGS="--save --save-temp --ts=$CURRENTTS";
npm run benchmark:easylist -- $FLAGS && npm run benchmark:easylist+AA --$FLAGS && npm run benchmark:allFilters -- $FLAGS && npm run benchmark:match:all -- $FLAGS && npm run benchmark:match:all:easylist -- $FLAGS && npm run benchmark:match:all:easylist+AA -- $FLAGS && npm run benchmark:match:all:allFilters -- $FLAGS --dt
#git checkout origin master
npm install
REFSTS=$(date +%FT%TZ)
FLAGS="--save --save-temp --ts=$REFSTS";
npm run benchmark:easylist --$FLAGS && npm run benchmark:easylist+AA --$FLAGS && npm run benchmark:allFilters -- $FLAGS && npm run benchmark:match:all -- $FLAGS && npm run benchmark:match:all:easylist -- $FLAGS && npm run benchmark:match:all:easylist+AA -- $FLAGS && npm run benchmark:match:all:allFilters -- $FLAGS --dt
npm  --current=$CURRENTTS --refs=$REFSTS run test benchmark/compare-results.js

if [[ "$EXTENDHISTORICAL" == true ]]; then
  sh benchmark/fetchAndExtendHistoricalData.sh $REFSTS
fi

