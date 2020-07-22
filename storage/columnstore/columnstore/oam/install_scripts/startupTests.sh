#!/bin/bash
#
# $Id: startupTests.sh 2937 2012-05-30 18:17:09Z rdempsey $
#
# startupTests - perform sanity testing on system DB at system startup time
#				 called by Process-Monitor

# Source function library.
if [ -f /etc/init.d/functions ]; then
	. /etc/init.d/functions
fi

. /usr/share/columnstore/columnstore_functions

for testScript in /usr/share/columnstore/mcstest*.sh; do
	if [ -x $testScript ]; then
		eval $testScript
		rc=$?
		if [ $rc -ne 0 ]; then
			cplogger -c 51 $testScript
			echo "FAILED, check Critical log for additional info"
			exit $rc
		fi
	fi
done
echo "OK"

cplogger -i 54

exit 0

