#!/bin/bash

build_pack()
{
    # Copy static docker binaries
    bandit_mkdir $BUILD_PACK/usr/bin
    cp -vR docker/* $BUILD_PACK/usr/bin

    # Configure dockerd
    bandit_mkdir $BUILD_PACK/etc/docker/
    cat > $BUILD_PACK/etc/docker/daemon.json <<EOF
{
"hosts": ["unix:///var/run/docker.sock", "tcp://127.0.0.1:2375"]
}
EOF

    # Add init script
    bandit_mkdir $BUILD_PACK/etc/init.d
    cat > $BUILD_PACK/etc/init.d/dockerd <<"EOF"
#!/bin/bash
#
# Copyright (C) 2018 Angel Linares Zapater
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as 
# published by the Free Software Foundation. See the COPYING file.
#
# This program is distributed WITHOUT ANY WARRANTY; without even the 
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
#
### BEGIN INIT INFO
# Provides:          dockerd
# Required-Start:    $remote_fs $network $syslog
# Should-Start:
# Required-Stop:     $remote_fs $network $syslog
# Required-Stop:     $remote_fs
# Should-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Docker daemon
# Description:       Docker daemon
### END INIT INFO

. /lib/lsb/init-functions

_docker_mount_cgroups()
{
    # Mount cgroups
    if ! mountpoint -q /sys/fs/cgroup; then
       mount -t tmpfs -o uid=0,gid=0,mode=0755 cgroup /sys/fs/cgroup
       for sys in $(awk '!/^#/ { if ($4 == 1) print $1 }' /proc/cgroups); do
           local file=/sys/fs/cgroup/$sys 
           mkdir -p $file 
 	   if ! mountpoint -q $file; then
	      if ! mount -n -t cgroup -o $sys cgroup $file; then
 	 	 rmdir $file
	      fi
	   fi
       done
    fi 
}

case "$1" in
   start)
      _docker_mount_cgroups
      log_info_msg "Starting Docker daemon..."
      /usr/bin/dockerd 2>/var/log/docker.log & 
      evaluate_retval
      ;;
   stop)
      log_info_msg "Stopping Docker daemon..."
      killproc /usr/bin/dockerd
      evaluate_retval
      ;;
   restart)
      $0 stop
      sleep 1
      $0 start
      ;;
   status)
      statusproc /usr/sbin/dockerd
      ;;
   *)
      echo "Usage: $0 {start|stop|restart|status}"
      exit 1
      ;;
esac
EOF
    chmod 754 $BUILD_PACK/etc/init.d/dockerd
    for i in 2 3 4 5; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/dockerd $BUILD_PACK/etc/rc.d/rc$i.d/S30dockerd
    done
    for i in 0 1 6; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/dockerd $BUILD_PACK/etc/rc.d/rc$i.d/K40dockerd
    done
}

install_setup()
{
    /etc/init.d/dockerd start 
}

remove_setup()
{
    /etc/init.d/dockerd stop
}

