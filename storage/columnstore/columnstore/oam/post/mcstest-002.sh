#!/bin/bash
#
# $Id: test-002.sh 2937 2012-05-30 18:17:09Z rdempsey $


USER=`whoami 2>/dev/null`

# Source function library.
if [ -f /etc/init.d/functions ]; then
	. /etc/init.d/functions
fi

. /usr/share/columnstore/functions

scrname=`basename $0`
tname="check-brm"

#Don't run on first boot
if firstboot; then
	exit 0
fi

#Make sure BRM is read-write

cplogger -i 48 $scrname "$tname"

#turn this test off for now...it doesn't if the DBRM isn't started, and these tests run too early
# we need a way to run some tests at different stages of system startup...
#dbrmctl status 2>&1 | egrep -qsi '^ok'
/bin/true
rc=$?

if [ $rc -ne 0 ]; then
	cplogger -c 50 $scrname "$tname" "the BRM is read only"
	exit 1
fi

cplogger -i 52 $scrname "$tname"

exit 0

