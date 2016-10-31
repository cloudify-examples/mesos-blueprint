#!/bin/bash

if [ ! -d ${HOME}/mesos ]; then
  mkdir ${HOME}/mesos
fi
  
nohup ${MESOS_HOME}/bin/mesos-slave.sh --containerizers=${CONTAINERIZERS} --ip=${HOST_IP} --master=${MASTER_IP}:5050 --work_dir=${HOME}/mesos > /tmp/mesos.out 2>/tmp/mesos.err &
