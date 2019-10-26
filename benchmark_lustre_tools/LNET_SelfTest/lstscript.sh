#!/bin/bash
#
# Simple wrapper script for LNET Selftest
#
#Output file
ST=lst-output-$(date +%Y-%m-%d-%H:%M:%S)
#Size
SZ=1M
# Length of time to run test (secs)
TM=60
# Which BRW test to run (read or write)
BRW=write
# Checksum calculation (simple or full)
CKSUM=simple
# The LST "from" list -- e.g. Lustre clients. Space separated list of NIDs.
LFROM="10.0.0.28@tcp"
# The LST "to" list -- e.g. Lustre servers. Space separated list of NIDs.
LTO="10.0.0.14@tcp 10.0.0.3@tcp 10.0.0.11@tcp"
### End of customisation.
#for CN in 4 8 16 32 64 128 256 512; do
# CN=Concurrency
 
for CN in 4 8 16; do
        echo "####### START ####### CONCURRENCY = $CN"
        export LST_SESSION=$$
        echo LST_SESSION = ${LST_SESSION}
        lst new_session lst${BRW}
        lst add_group lfrom ${LFROM}
        lst add_group lto ${LTO}
        lst add_batch bulk_${BRW}
        lst add_test --batch bulk_${BRW} --from lfrom --to lto brw ${BRW} --concurrency=${CN} check=${CKSUM} size=${SZ}
        lst run bulk_${BRW}
        echo -n "Capturing statistics for ${TM} secs "
        lst stat --mbs lfrom lto 2>&1 | tee ${ST}-${CN} &
        #lst stat lfrom lto &
        LSTPID=$!
        # Delay loop with interval markers displayed every 5 secs. Test time is rounded
        # up to the nearest 5 seconds.
        i=1
        j=$((${TM}/5))
        if [ $((${TM}%5)) -ne 0 ]; then let j++; fi
        while [ $i -le $j ]; do
                sleep 5
                let i++
        done
        echo
        kill ${LSTPID}
        lst show_error lfrom lto
        lst stop bulk_${BRW}
        lst end_session
        echo "####### END"
        echo
done
