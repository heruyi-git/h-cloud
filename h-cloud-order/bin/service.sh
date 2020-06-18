#!/bin/sh

# bin目录绝对路径
BIN_PATH=$(cd `dirname $0`; pwd)
# 进入bin目录
cd `dirname $0`
# 返回到上一级项目根目录路径
cd ..
# 打印项目根目录绝对路径
# `pwd` 执行系统命令并获得结果
BASE_PATH=`pwd`

# 外部配置文件绝对目录,如果是目录需要/结尾，也可以直接指定文件
# 如果指定的是目录,spring则会读取目录中的所有配置文件
CONFIG_DIR=${BASE_PATH}/conf/
LIB_DIR=${BASE_PATH}/lib

APP_NAME="${BASE_PATH##*/}.jar"
APP_PATH=${BASE_PATH}/bin/${APP_NAME}
cd ${BASE_PATH}/bin

#echo $APP_NAME
#echo $BASE_PATH
#echo $APP_PATH

usage() {
    echo "Usage: sh service.sh [start|stop|restart|status]"
    exit 1
}
is_exist(){
  pid=`ps -ef|grep $APP_NAME|grep -v grep|awk '{print $2}' `
  if [ -z "${pid}" ]; then
   return 1
  else
    return 0
  fi
}

start(){
  is_exist
  if [ $? -eq "0" ]; then
    echo "${APP_NAME} is already running. pid=${pid} ."
  else
    echo "###${APP_NAME} starting..."
    #==========================================================================================
    # JVM Configuration
    # -Xmx256m:设置JVM最大可用内存为256m,根据项目实际情况而定，建议最小和最大设置成一样。
    # -Xms256m:设置JVM初始内存。此值可以设置与-Xmx相同,以避免每次垃圾回收完成后JVM重新分配内存
    # -Xmn512m:设置年轻代大小为512m。整个JVM内存大小=年轻代大小 + 年老代大小 + 持久代大小。
    #          持久代一般固定大小为64m,所以增大年轻代,将会减小年老代大小。此值对系统性能影响较大,Sun官方推荐配置为整个堆的3/8
    # -XX:MetaspaceSize=64m:存储class的内存大小,该值越大触发Metaspace GC的时机就越晚
    # -XX:MaxMetaspaceSize=320m:限制Metaspace增长的上限，防止因为某些情况导致Metaspace无限的使用本地内存，影响到其他程序
    # -XX:-OmitStackTraceInFastThrow:解决重复异常不打印堆栈信息问题
    #==========================================================================================
    JAVA_OPT="-server -Dfile.encoding=UTF-8 -Dloader.path=${LIB_DIR}"
    JAVA_OPT="${JAVA_OPT} -Xms256m -Xmx256m -Xmn512m -XX:MetaspaceSize=64m -XX:MaxMetaspaceSize=256m"
    JAVA_OPT="${JAVA_OPT} -XX:-OmitStackTraceInFastThrow"

    echo "java ${JAVA_OPT} -jar  ${APP_PATH} --spring.config.location=${CONFIG_DIR} >/dev/null 2>&1 &"
  	source /etc/profile;  nohup java ${JAVA_OPT} -jar  ${APP_PATH} --spring.config.location=${CONFIG_DIR} >/dev/null 2>&1 &
    echo "###${APP_NAME} start Success."
  fi
}

stop(){
  is_exist
  if [ $? -eq "0" ]; then
    kill -9 ${pid}
    echo "###${APP_NAME} - $pid stop finished"
  else
    echo "${APP_NAME} is not running"
  fi
}

status(){
  is_exist
  if [ $? -eq "0" ]; then
    echo "${APP_NAME} is running. Pid is ${pid}"
  else
    echo "${APP_NAME} is NOT running."
  fi
}

restart(){
  stop
  start
}

case "$1" in
  "start")
    start
    ;;
  "stop")
    stop
    ;;
  "status")
    status
    ;;
  "restart")
    restart
    ;;
  *)
    usage
    ;;
esac
