#!/bin/bash

if [ ! -d ${HOME}/mesos ]; then
  mkdir ${HOME}/mesos
fi
  
nohup ${MESOS_HOME}/bin/mesos-master.sh --ip=${HOST_IP} --work_dir=${HOME}/mesos > /tmp/mesos.out 2>/tmp/mesos.err &
