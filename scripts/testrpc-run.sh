#!/usr/bin/env bash

# prepare testrpc accounts parameter string e.g. --account="0x11c..,1000" --account="0xc5d...,1000" ....
source ./scripts/testrpc-accounts.sh
accounts=""
for i in ${!account_array[@]}; do
    accounts+=$(printf '%saccount=%s,%s' "--" "${account_array[i]}" "$balance")
    /usr/libexec/PlistBuddy -c "Set ACCOUNT_'$i'_PRIVATE_KEY '${account_array[i]}'" KinSDK/KinSDKTests/testConfig.plist
    if [ $i -lt 10 ]; then
        accounts+=" "
    fi
done
if (nc -z localhost 8545); then
    echo "Using existing testrpc instance on port $(ps -fade | grep -e 'node.*testrpc' | head -n 1 | awk '{print $2}')"
else
    echo -n "Starting testrpc instance on port $port "
    testrpc ${accounts} -u 0 -u 1 -p "$port" > testrpc.log 2>&1 & echo $! > testrpc.pid
    echo $(cat testrpc.pid)
fi
