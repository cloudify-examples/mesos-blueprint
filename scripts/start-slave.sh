#!/bin/bash

if [ ! -f /etc/sv/mesos-slave/run ]; then
    if [ ! -d ${HOME}/mesos ]; then
      mkdir ${HOME}/mesos
    fi
    nohup ${MESOS_HOME}/bin/mesos-slave.sh --containerizers=${CONTAINERIZERS} --ip=${HOST_IP} --master=${MASTER_IP}:5050 --work_dir=${HOME}/mesos > /tmp/mesos.out 2>/tmp/mesos.err &
else
    nohup /etc/sv/mesos-slave/run > /tmp/mesos-slave-nuhup.out&
fi
