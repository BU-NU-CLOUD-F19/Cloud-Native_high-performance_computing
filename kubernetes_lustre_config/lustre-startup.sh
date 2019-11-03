#!/bin/sh

#kubectl create secret generic vmi-lustre-secret --from-file=userdata=lustre-startup.sh
#export NEW_USER="foo"
export SSH_PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmkaDRsJMcUQGV2euLicgMxVhSDGN+sae/QoLkDVyZLAV6d/8tST3ZOevVoWtg4N10R1x3WlzbjeR4G59rKS2iHyz76GmlHBYFrwD7SXI23IIxlDgwnndyn33Qobw/RxHcfqc8YlDR/xGexqGvKqDg37RMyooirXj0WkfzT6PKOnSHGIKWYzoT6Qipq4yvJVxTVF6uSo2jt1H7PrGamLNO1Dk0F6EPF0T88z4kYcBVNL+/P4YkvFJ4uZRTg92B9ROfHa6X+Wy8fmoZG2ieJwmySl5yNbUWqNegNlpQqU4n/Pp/FJcZWAPPBqH8XPTLhrYXYeKrxJDR1WsRJgH9nW8/ moc-lustre"

#sudo adduser -U -m $NEW_USER
export DEFAULT_USER="centos"
echo "$DEFAULT_USER:centos" | chpasswd
sudo mkdir /home/$DEFAULT_USER/.ssh
sudo echo "$SSH_PUB_KEY" > /home/$DEFAULT_USER/.ssh/authorized_keys
sudo chown -R ${DEFAULT_USER}: /home/$DEFAULT_USER/.ssh

if [ ! -c /dev/lnet ] ; then
   sudo exec /sbin/modprobe -v lnet >/dev/null 2>&1
fi


/sbin/lsmod | /bin/grep lustre 1>/dev/null 2>&1
if [ $? -ne 0 ] ; then
   sudo /sbin/modprobe -v lustre >/dev/null 2>&1
fi


/sbin/lsmod | /bin/grep zfs 1>/dev/null 2>&1
if [ $? -ne 0 ] ; then
   sudo /sbin/modprobe -v zfs >/dev/null 2>&1
fi
