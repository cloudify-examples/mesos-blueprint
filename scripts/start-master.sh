#!/bin/bash

if [ ! -f /etc/sv/mesos-master/run ]; then
    if [ ! -d ${HOME}/mesos ]; then
      mkdir ${HOME}/mesos
    fi
    nohup ${MESOS_HOME}/bin/mesos-master.sh --ip=${HOST_IP} --work_dir=${HOME}/mesos > /tmp/mesos.out 2>/tmp/mesos.err &
else
    nohup /etc/sv/mesos-master/run > /tmp/mesos-master-nuhup.out&
fi
