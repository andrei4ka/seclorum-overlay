#!/bin/bash 
#
#
# chkconfig: 2345 80 05
# description: This is a program that is responsible for taking care of
# configuring the Oracle Database 10g Express Edition and its associated 
# services. 
#
# processname: oracle-xe 
# config: /etc/conf.d/oracle-xe
#
# change log:
#	svaggu -  creation 28-Sep-2005

ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server
ORACLE_OWNER=oraclexe
ORACLE_GROUP=dba
ORACLE_SID=XE
LSNR=$ORACLE_HOME/bin/lsnrctl
SQLPLUS=$ORACLE_HOME/bin/sqlplus
SU=/bin/su
export ORACLE_HOME
export ORACLE_SID
export ORACLE_OWNER
export ORACLE_GROUP
export PATH=$ORACLE_HOME/bin:$PATH
LOG="$ORACLE_HOME_LISTNER/listener.log"

export LC_ALL=C

if [ $(id -u) != "0" ]
then
    echo "You must be root to run the configure script.  Login as root and then run the 
configure script."
    exit 1
fi

#
# write_sysconfig()
#
# Writes the system configuration
#
write_sysconfig()
{
	cat >/etc/conf.d/oracle-xe <<EOF
    
#This is a configuration file for automatic starting of the Oracle
#Database and listener at system startup.It is generated By running
#'/usr/lib/oracle/xe/app/oracle/product/10.2.0/server/bin/oracle_configure.sh'
#Please use that method to modify this file

# LISTENER_PORT:
LISTENER_PORT=${LISTENER_PORT}

# HTTP_PORT
HTTP_PORT=${HTTP_PORT}

#Configuration
CONFIGURE_RUN=${CONFIGURE_RUN}

EOF
	
    if [ $? != 0 ]
	then
		return 1
	fi
	return 0
}

# configure_perform()
#
# Instantantiate listener.ora,tnsnames.ora,and create the database,
# sets the password,start the listener,and adds database to inittab
# if necessary

configure_perform()
{
    sed -i "s/%hostname%/`hostname`/g" $ORACLE_HOME/network/admin/listener.ora
    sed -i "s/%port%/$LISTENER_PORT/g" $ORACLE_HOME/network/admin/listener.ora

    sed -i "s/%port%/$LISTENER_PORT/g" $ORACLE_HOME/network/admin/tnsnames.ora
    sed -i "s/%hostname%/`hostname`/g" $ORACLE_HOME/network/admin/tnsnames.ora

    sed -i "s/%httpport%/$HTTP_PORT/g" $ORACLE_HOME/config/scripts/postDBCreation.sql
    sed -i "s/%FRA_DIR%/\/usr\/lib\/oracle\/xe\/app\/oracle\/flash_recovery_area/g" $ORACLE_HOME/config/scripts/postDBCreation.sql

    sed -i "s/%port%/$LISTENER_PORT/g" $ORACLE_HOME/config/scripts/init.ora
    sed -i "s/%hostname%/`hostname`/g" $ORACLE_HOME/config/scripts/init.ora

    # SGA and PGA Voodoo
    TM=`cat /proc/meminfo | grep '^MemTotal' | awk '{print $2}'`
    TM=`echo 0.40 \* $TM | bc | sed "s/\..*//"`
    TMSP=`echo $TM-40960 | bc`
    # Memory Limit of XE
    if [ $TMSP -gt 999999 ]; then
    	TMSP=999999
    fi
    sga=`echo 0.75 \* $TMSP \* 1024 | bc | sed "s/\..*//"`
    pga=`echo 0.25 \* $TMSP \* 1024 | bc | sed "s/\..*//"`

    if [ $sga -lt 146800640 ]; then
	sga=146800640
    fi

    if [ $pga -lt 16777216 ]; then
	pga=16777216
    fi

    sed -i "s/%sga_target%/$sga/g" $ORACLE_HOME/config/scripts/init.ora
    sed -i "s/%pga_aggregate_target%/$pga/g" $ORACLE_HOME/config/scripts/init.ora

    sed -i "s/%sga_target%/$sga/g" $ORACLE_HOME/config/scripts/initXETemp.ora
    sed -i "s/%pga_aggregate_target%/$pga/g" $ORACLE_HOME/config/scripts/initXETemp.ora

    #sed -i "s/%httpport%/$HTTP_PORT/g" /usr/share/applications/oraclexe-GotoDBHome.desktop
    #sed -i "s/%httpport%/$HTTP_PORT/g" /usr/share/applications/oraclexe-ReadOnlineHelp.desktop


    homedir=`echo $HOME`
    if [ "$homedir" == "/root" ]
    then
        homedir=`sh -c "echo ~$USER"`
    fi

    if [ -f $homedir/.gnome-desktop/oraclexe-GettingStartedDesktop.desktop ]  
    then
    	    chown $ORACLE_OWNER:$ORACLE_GROUP $homedir/.gnome-desktop/oraclexe-GettingStartedDesktop.desktop
    	    chmod 664  $homedir/.gnome-desktop/oraclexe-GettingStartedDesktop.desktop
    fi
    if [ -f $homedir/Desktop/oraclexe-GettingStartedDesktop.desktop ]
    then
	chown $ORACLE_OWNER:$ORACLE_GROUP $homedir/Desktop/oraclexe-GettingStartedDesktop.desktop
	chmod 664  $homedir/Desktop/oraclexe-GettingStartedDesktop.desktop
    fi

    mkdir /usr/lib/oracle/xe/oradata/XE -p
    chmod -R 640 /usr/lib/oracle/xe/oradata/XE
    chmod 750 /usr/lib/oracle/xe/oradata/XE
    chown -R $ORACLE_OWNER:$ORACLE_GROUP /usr/lib/oracle

    chown -R root:$ORACLE_GROUP $ORACLE_HOME/bin
    chmod -R 755 $ORACLE_HOME/bin
    chmod 6751 $ORACLE_HOME/bin/oracle


    if [ -f /etc/oratab ]
    then
        echo "XE:$ORACLE_HOME:N" >> /etc/oratab
    else
        echo "XE:$ORACLE_HOME:N" >> /etc/oratab
        chown $ORACLE_OWNER:$ORACLE_GROUP /etc/oratab
        chmod 644 /etc/oratab
    fi


    echo Configuring Database...

    SQLPLUS="$ORACLE_HOME/bin/sqlplus"
    $SU $ORACLE_OWNER -c "$ORACLE_HOME/config/scripts/XE.sh"

    echo  "alter user flows_020100 identified by \"$ORACLE_PASSWORD\";" | $SU $ORACLE_OWNER -c "$SQLPLUS -s / as sysdba" 
    echo  "alter user sys identified by \"$ORACLE_PASSWORD\";" | $SU $ORACLE_OWNER -c "$SQLPLUS -s / as sysdba" 
    echo  "alter user system identified by \"$ORACLE_PASSWORD\";" | $SU $ORACLE_OWNER -c "$SQLPLUS -s / as sysdba" 
    echo  "alter user flows_files identified by \"$ORACLE_PASSWORD\";" | $SU $ORACLE_OWNER -c "$SQLPLUS -s / as sysdba" 
    echo  "alter user anonymous identified by \"$ORACLE_PASSWORD\";" | $SU $ORACLE_OWNER -c "$SQLPLUS -s / as sysdba"

    $SU $ORACLE_OWNER -c "$ORACLE_HOME/bin/sqlplus -s /nolog @$ORACLE_HOME/config/scripts/stopdb.sql"

    chmod -R 640 /usr/lib/oracle/xe/oradata/XE
    chmod 750 /usr/lib/oracle/xe/oradata/XE
    chown -R oraclexe:dba /usr/lib/oracle/xe
    rm -fr $ORACLE_HOME/config/seeddb 

    echo "Done."
    echo
    echo "To start oracle-xe, run:"
    echo "/etc/init.d/oracle-xe start"
    echo "and point your Browser to:"
    echo "http://localhost:$HTTP_PORT/apex/"
    echo
    echo "Log in using username system and the password you supplied..."
    echo

}

#
#configure_ask()
#
# Ask configuration questions,setting the variables.
#

configure_ask()
{
	cat <<EOF

Oracle Database 10g Express Edition Configuration
-------------------------------------------------
This will configure on-boot properties of Oracle Database 10g Express 
Edition.  The following questions will determine whether the database should 
be starting upon system boot, the ports it will use, and the passwords that 
will be used for database accounts.  Press <Enter> to accept the defaults. 
Ctrl-C will abort.

EOF

    #get the http port value
	while :
	do
	    while [ 1 ]
	    do
            echo -n Specify the HTTP port that will be used for HTML DB [8080]:
            read LINE
            if [ -z $LINE ]
            then
                LINE=8080
            fi
            port=`netstat -n --tcp --listen | grep :$LINE | awk '{print $4}' | cut -d':' -f2`
            if [ "$port" = "$LINE" ]
            then
                echo Port $port appears to be in use by another application.\
                Please specify a different port.
            else
                break;
            fi
        done

	    case "$LINE" in
	    "")
            break
            ;;
        *[^0-9]*)
            echo "Invalid http port: $LINE" >&2
            ;;
        *)
            HTTP_PORT=$LINE
            break
            ;;
	    esac
	done
    
    #get the listener port value
	while : 
	do
        echo 
        while [ 1 ]
        do
            echo -n Specify a port that will be used for the database listener [1521]:
            read LINE
            if [ -z $LINE ]
            then
                LINE=1521
            fi
            echo
            port=`netstat -n --tcp --listen | grep :$LINE | awk '{print $4}' | cut -d':' -f2`
            if [ "$port" = "$LINE" ]
            then	
                echo Port $port appears to be in use by another application.\
                Please specify a different port.
            else
                break;
            fi
        done
	          
        case "$LINE" in
        "")
            break
            ;;
        *[^0-9]*)
            echo "Invalid port: $LINE" >&2
            ;;
	    *) 
            LISTENER_PORT=$LINE
	      	break
            ;;
	    esac
	done
    
    #get the database password
	    while :
	    do
	    echo -n "Specify a password to be used for database accounts.  Note that the same
password will be used for SYS, SYSTEM and FLOWS_020100.  Oracle recommends
the use of different passwords for each database account.  This can be done
after initial configuration:"
	   while [ 1 ]
	   do
	     stty -echo
	     read LINE
	     while [ -z $LINE ]
	     do
	     echo
	     echo -n "Password can't be null.  Enter password:"
		read LINE
	     done
	     if [ -n $LINE ]
	     then
		echo
		echo -n "Confirm the password:"
	        read LINE1
		echo
                if [ "$LINE" != "$LINE1" ];
		then
		echo    
		echo -n "Passwords do not match.  Enter the password:"
		else
		     break;
		fi
	     fi
	   done
	
	   case "$LINE" in
	   
	    *[^a-zA-Z0-9]*)
            echo "Invalid password: $LINE" >&2
            ;;
	   *)
            stty echo
            ORACLE_PASSWORD=$LINE
            break
            ;;
	   esac
	done
}

configure()
{
	configure_ask
	configure_perform
	CONFIGURE_RUN=true
	write_sysconfig
}

configure
