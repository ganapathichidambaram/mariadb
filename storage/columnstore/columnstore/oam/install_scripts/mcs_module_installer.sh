#!/usr/bin/expect
#
# Install custom OS files on system
# Argument 0 - Remote Module Name
# Argument 1 - Remote Server Host Name or IP address
# Argument 2 - Root Password of remote server
# Argument 3 - Debug flag 1 for on, 0 for off
# Argument 4 - Username on remote server (root default)
set timeout 30
set USERNAME root
set MODULE [lindex $argv 0]
set SERVER [lindex $argv 1]
set PASSWORD [lindex $argv 2]
set DEBUG [lindex $argv 3]
set USERNAME "root"
set UNM [lindex $argv 4]
if { $UNM != "" } {
	set USERNAME $UNM
}

set HOME "$env(HOME)"

log_user $DEBUG
spawn -noecho /bin/bash
#

#check and see if remote server has ssh keys setup, set PASSWORD if so
send_user " "
send "ssh -v $USERNAME@$SERVER 'time'\n"
set timeout 60
expect {
	"authenticity" { send "yes\n" 
    exp_continue
	}
	"word: " { send "$PASSWORD\n"
    exp_continue
	}
	"passphrase" { send "$PASSWORD\n" 
    exp_continue
	}
	"Exit status 0" { send_user "DONE"}	
	"Exit status 1" { send_user "FAILED: Login Failure\n" ; exit 1 }
	"Host key verification failed" { send_user "FAILED: Host key verification failed\n" ; exit 1 }
	"service not known" { send_user "FAILED: Invalid Host\n" ; exit 1 }
	"Permission denied, please try again"   { send_user "ERROR: Invalid password\n" ; exit 1 }
	"Connection refused"   { send_user "ERROR: Connection refused\n" ; exit 1 }
	"Connection closed"   { send_user "ERROR: Connection closed\n" ; exit 1 }
	"No route to host"   { send_user "ERROR: No route to host\n" ; exit 1 }
	timeout { send_user "ERROR: Timeout to host\n" ; exit 2 }
}
send_user "\n"

send_user "Stop ColumnStore service                       "
send "ssh -v $USERNAME@$SERVER 'pkill ProcMon; pkill ProcMgr'\n"
set timeout 60
# check return
expect {
	"word: " { send "$PASSWORD\n"
    exp_continue
	}
	"passphrase" { send "$PASSWORD\n" 
    exp_continue
	}
#	"No such file or directory" { send_user "DONE" }
        "Exit status 127" { send_user "DONE" }
	 "Exit status 0" { send_user "DONE" }
	"Read-only file system" { send_user "ERROR: local disk - Read-only file system\n" ; exit 1}
	timeout { send_user "DONE" }
}
send_user "\n"

#
# copy over custom OS tmp files
#
send_user "Copy Custom OS files to Module                  "
send_user " \n"
send "scp -rv /var/lib/columnstore/local/etc $USERNAME@$SERVER:/var/lib/columnstore/local\n"
set timeout 120
expect {
	"word: " { send "$PASSWORD\n"
    exp_continue
	}
	"passphrase" { send "$PASSWORD\n" 
    exp_continue
	}
	"Exit status 0" { send_user "DONE" }
	"scp :"  	{ send_user "ERROR\n" ; 
				send_user "\n*** Installation ERROR\n" ; 
				exit 1 }
	"Read-only file system" { send_user "ERROR: local disk - Read-only file system\n" ; exit 1}
	timeout { send_user "ERROR: Timeout\n" ; exit 2 }
}
send_user "\n"

#
# copy over MariaDB Columnstore Module file
#
send_user "Copy MariaDB Columnstore Module file to Module                 "
send "scp -v /var/lib/columnstore/local/etc/$MODULE/*  $USERNAME@$SERVER:/var/lib/columnstore/local/.\n"
set timeout 120
expect {
	"word: " { send "$PASSWORD\n"
    exp_continue
	}
	"passphrase" { send "$PASSWORD\n" 
    exp_continue
	}
	"scp :"  	{ send_user "ERROR\n" ; 
				send_user "\n*** Installation ERROR\n" ; 
				exit 1 }
	"Exit status 0" { send_user "DONE" }
	"Exit status 1" { send_user "ERROR: scp failed" ; exit 1 }
	timeout { send_user "ERROR: Timeout to host\n" ; exit 2 }
}
send_user "\n"

send_user "Start ColumnStore service                       "
send_user " \n"
send "ssh -v $USERNAME@$SERVER 'columnstore start'\n"
set timeout 60
# check return
expect {
	"word: " { send "$PASSWORD\n"
    exp_continue
	}
	"passphrase" { send "$PASSWORD\n" 
    exp_continue
	}
    "Exit status 0" { send_user "DONE" }
    "Exit status 127" { send_user "ERROR: columnstore Not Found\n" ; exit 1 }
    timeout { send_user "ERROR: Timeout to host\n" ; exit 2 }
}

send_user "\n"

send_user "\nInstallation Successfully Completed on '$MODULE'\n"
exit 0

