#!/bin/sh
#cat ~/demo.sh

SHELL_DIR=$(cd `dirname $0`; pwd)

#############################################   循环   #############################################
TestWhile(){
    FILE=${SHELL_DIR}/../conf/ip.txt
    i=0
    while read -r line
    do
        if((i == 0))
        then
            host=$(echo $line |awk '{print $1}')
        fi
        i=$((i+1))  #在循环内部生效
    done < $FILE

    cat $FILE |grep -v '#' | while read line
    do
        host=$(echo $line |awk '{print $1}')
        user=$(echo $line |awk '{print $2}')
        passwd=$(echo $line |awk '{print $3}')
        if [[ $host == "localhost" ]]
        then
            echo "cd ${SHELL_DIR}/local; ./replace.sh $tsdb_host $tsdb_port"
            cd ${SHELL_DIR}/local; ./replace.sh $tsdb_host $tsdb_port
        else
            echo "cd ${SHELL_DIR}/remote; ./remote.sh replace ${host} ${user} ${passwd} $tsdb_host $tsdb_port"
            cd ${SHELL_DIR}/remote; ./remote.sh replace ${host} ${user} ${passwd} $tsdb_host $tsdb_port
        fi
    done
}

TestWhile2(){
    # <
    num=5
    while (( $num < 10 ))
    do
      echo "$num"
      num=$((num+1))
    done

    # or
    cnt=0
    cnt2=1
    while (( cnt ==0 || cnt2 == 0 ));
    do
        echo "cnt:$cnt cnt2:$cnt2"
    done

    # and
    cnt=0
    cnt2=1
    while (( cnt ==0 && cnt2 == 1));
    do
        echo "111"
    done

    # 死循环
    while (( 1==1))
    do
        echo "in endless loop"
    done
}

TestWhileTrue(){
    while [ true ]  #work
    do
        echo "true"
        sleep 1
    done
}

TestFor(){
    for (( i=0; i< 5; i++ ))
    do
        echo "i:$i"
    done
}

#############################################   判断   #############################################
TestIf(){
    FILE=${SHELL_DIR}/check_alive_flag
    if [ -f "$FILE" ]; then
        echo "$FILE is exist."
    elif [ ! -f "$FILE" ]; then   #非
        echo "$FILE is not exist."
    fi

    host="localhost"
    if [ "$host" == "localhost" ]
    then
        echo "equal"
    fi

    if [ -n "$host" ]
    then
        echo "host is not null"
    fi

    host_test=""
    if [ -z "$host_test" ]
    then
        echo "host_test is null"
    fi
}

#############################################   计算   #############################################
TestCalculation(){
    #if (( 2 * 3 == 6 )) then  #error
    #    echo true
    #fi

    if (( 2 * 3 == 6 ))
    then
        echo true
    fi
}

#  () 在子shell中运行
#  (()) 表达式扩展
#$(( )) 中的变量名称，可于其前面加 $ 符号来替换，也可以不用
# 如果a为空，那么[ $a -eq 0 ]会报错，但是[[ $a -eq 0 ]]不会，所以一般都会使用[[]]或者是 [ "$a" -eq 0 ]
DIR="/usr/local"
if [ ${#DIR} -gt 1 ];
then
     HITSDB_LOG_DIR=$DIR
     echo "$DIR length > 1"
fi

a=5;
((a++))
echo "a:$a"

if [ $a -gt 3 ]
then
  echo "$a is greater than 3"
elif [ $a -eq 5 ]
then
  echo "$a is equal to 5"
elif [ $a -lt 9 ]
then
  echo "$a is less than 9"
fi

if [[ $a -gt 3 && $a -lt 9 ]]
then
  echo "$a is greater than 3 and less than 9"
fi

if (( a > 3 && a < 9 ))
then
  echo "$a is greater than 3 or less than 9"
fi

if [[ $a -gt 10 ||  $a -lt 9 ]]
then
  echo "$a is greater than 10 or less than 9"
fi

if (( a > 10 || a < 9 ))
then
  echo "$a is greater than 10 and less than 9"
fi

for (( i > 0; i <3;  i++ ))
do
    echo $i
done

if (( 2 * 3 == 6 )); then
    echo true
fi

#if (( 2 * 3 == 6 )) then  #error
#    echo true
#fi

if (( 2 * 3 == 6 ))
then
    echo true
fi

host="localhost"
if [ "$host" == "localhost" ]
then
    echo "equal"
fi

if [ -n "$host" ]
then
    echo "host is not null"
fi

host_test=""
if [ -z "$host_test" ]
then
    echo "host_test is null"
fi

param1="start"
case $param1 in
     start | begin)
       echo "start something"
     ;;
     stop | end)
       echo "stop something"
     ;;
     *)
       echo "Ignorant"
     ;;
esac

#整数比较：
#-eq                       等于            if [ "$a" -eq "$b" ]
#-ne                       不等于         if [ "$a" -ne "$b" ]
#-gt                        大于            if [ "$a" -gt "$b" ]
#-ge                       大于等于      if [ "$a" -ge "$b" ]
#-lt                         小于            if [ "$a" -lt "$b" ]
#-le                        小于等于      if [ "$a" -le "$b" ]

#<                          小于（需要双括号）       (( "$a" < "$b" ))
#<=                        小于等于(...)                (( "$a" <= "$b" ))
#>                          大于(...)                      (( "$a" > "$b" ))
#>=                        大于等于(...)                (( "$a" >= "$b" ))
#
#字符串比较：
#=                          等于           if [ "$a" = "$b" ]
#==                        与=等价
#!=                         不等于        if [ "$a" = "$b" ]
#<                          小于，在ASCII字母中的顺序：
#                            if [[ "$a" < "$b" ]]
#                            if [ "$a" \< "$b" ]         #需要对<进行转义
#>                          大于
#
#-z                         字符串为null，即长度为0
#-n                         字符串不为null，即长度不为0

#############################################   返回   #############################################
TestReturnAndExit(){
    cnt=$1
    if (( cnt >= 1 ))
    then
        echo "cnt:$cnt , return"
        return     #just return the function, not exit the scripts
    else
        echo "cnt < 1, exit the scripts"
        exit 0     #exit the scripts
    fi
}


#############################################   对象   #############################################
TestMap(){
    declare map=()
    for((i=0;i<3;i++))
    do
        map[$i]=$i
    done

    for key in ${!map[@]}
    do
        echo ${map[$key]}
    done

    declare mapExpect=()
    for((i=0;i<3;i++))
    do
        mapExpect[$i]=$i
    done

    for key in ${!mapExpect[@]}
    do
        valueExpect=${mapExpect[$key]}
        value=${map[$key]}
        if (( valueExpect != value ))
        then
            echo "valueExpect:$valueExpect not equal"
        else
            echo "valueExpect:$valueExpect is equal"
        fi
    done
}

#TestShellParams
#
#TestReturnAndExit 1
#TestIf

#TestCalculation

#############################################   其它   #############################################
TestXargs(){
    ls -l *.log |xargs rm -rf {}
}

TestPrintLine(){
    echo $LINENO
}

TestGit(){
    :
#alias gd='git diff --staged -p > /tmp/t.diff; ccc /tmp/t.diff; rm -rf /tmp/t.diff ; git diff --staged -p'
}

new()
{
     echo "func bkground pid by \$\$ is $$"
     while [ 1 == 1 ]
     do
           echo "func bkground pid by \$\$ is $$"
           sleep 5
     done
}

echo "current script pid is $$"
#函数单独在一个进程中执行。
new &

while [ 1 == 1 ]
do
    echo "current script pid is $$"
    sleep 5
done
