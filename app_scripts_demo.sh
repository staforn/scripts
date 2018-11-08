#!/usr/bin/env bash

echo $HBASE_HOME   #借用系统的变量
#   变量    含义
#   $0    当前脚本的文件名
#   $n    传递给脚本或函数的参数。n 是一个数字，表示第几个参数。例如，第一个参数是$1，第二个参数是$2。
#   $#    传递给脚本或函数的参数个数。
#   $*    传递给脚本或函数的所有参数。
#   $@    传递给脚本或函数的所有参数。被双引号(" ")包含时，与 $* 稍有不同，下面将会讲到。
#   $?    上个命令的退出状态，或函数的返回值。
#   $$    当前Shell进程ID。对于 Shell 脚本，就是这些脚本所在的进程ID。

TestParamNum(){
    if (( $# == 0 ))
    then
        echo "This script works without parameters, but is not recommended. It is recommended to use the following pattern instead."
        echo ""
        Help
        Put
        Query
        exit 0
    elif (( $# == 1 ))
    then
        Help
        exit 0
    elif (( $# >= 2 ))
    then
        host=$1
        port=$2
    fi
}

TestShellParams(){
    echo "curent_pid:$$"
    echo "params num:$#"
    PID=$$

    param1="begin"
    case $param1 in
         start | begin)
           echo "start something, param1:$param1"
         ;;
         stop | end)
           echo "stop something, param1:$param1"
         ;;
         *)
           echo "Ignorant"
         ;;
    esac
}

TestParams()
{
   echo "scripts name:$0"
   echo "params index: $n"
   echo "params nums: $#"
   echo "params: $*"
   echo "params: $@"
   echo "last command exit code: $?"
   echo "PID: $$"

}

TestCheck_alive()
{
    count=`jps |grep HMaster | grep -v grep  |wc -l `
    if (($count < 1))
    then
        echo "count: $count"
        ulimit -c 20000
        $HBASE_HOME/bin/start-hbase.sh
        echo `date` "restart hbase " >> $HBASE_HOME/bin/check_alive.log
    else
        echo `date` "hbase is already running. " >> $HBASE_HOME/bin/check_alive.log
    fi
}

RunService ()
{
    case $1 in
      start  ) StartService   ;;
      stop   ) StopService    ;;
      restart) RestartService ;;
      *      ) echo "$0: unknown argument: $1";;
    esac
}

GetPID ()
{
    local program="$1"
    local pidfile="${PIDFILE:=/var/run/${program}.pid}"
    local     pid=""

    if [ -f "${pidfile}" ]; then
    pid=$(head -1 "${pidfile}")
    if ! kill -0 "${pid}" 2> /dev/null; then
        echo "Bad pid file $pidfile; deleting."
        pid=""
        rm -f "${pidfile}"
    fi
    fi

    if [ -n "${pid}" ]; then
    echo "${pid}"
    return 0
    else
    return 1
    fi
}

TestPS(){
    #cnt=`ps -ef | grep $PID | grep -v grep`  # syntax error in expression (error token is "
    cnt=`ps -ef | grep $PID | grep -v grep | wc -l`  # correct
}

TestParams  1 2
