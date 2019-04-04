#!/bin/bash

# Source function library.
. /etc/init.d/functions
# Source networking configuration.
. /etc/sysconfig/network

function retVal()
{
    RETVAL=$?
    [ $RETVAL -eq 0 ] && success || failure
    echo
    return $RETVAL
}

function printHelp()
{
    echo Help:;
    echo "   $0"
}

# Set Java Env
export JAVA_HOME=/usr/local/jdk
export JAVA_BIN=/usr/local/jdk/bin
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JAVA_HOME JAVA_BIN PATH CLASSPATH

# Set JVM Env
export CATALINA_BASE=/home/ecloud/ins/api2
export CATALINA_HOME=/home/ecloud/app/tomcat
export CATALINA_OUT=/data/weblogs/api2/catalina.out
export LD_LIBRARY_PATH=$CATALINA_HOME/lib:/usr/local/apr/lib:/usr/local/apr

export CATALINA_OPTS="-Dcom.sun.management.jmxremote.port=9213 -Djava.library.path=/home/ecloud/app/tomcat/bin/tomcat-native-1.2.10-src/native/.libs"
export JAVA_OPTS="-server -Xms2400m -Xmx2400m -Xmn1200m -Xss256k -XX:PermSize=128m -XX:MaxPermSize=128m -Xverify:none -XX:+UseCMSCompactAtFullCollection -XX:CMSFullGCsBeforeCompaction=2 -XX:SurvivorRatio=1 -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:-CMSParallelRemarkEnabled -XX:+DisableExplicitGC -XX:+CMSClassUnloadingEnabled -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=85 -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/home/weblogs/jvm_dump.log -Djava.rmi.server.hostname=114.215.16.36 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
#CATALINA_OPTS JAVA_OPTS >/dev/null 2>&1

# Start tomcat
echo -n $"Starting Tomcat: "
$CATALINA_HOME/bin/startup.sh -config $CATALINA_BASE/conf/server.xml  > /dev/null 2>&1
retVal
