#Tsung In Docker Swarm
#base on ubuntu
FROM ubuntu:16.04
MAINTAINER FFantasy <https://github.com/ffantasy>

#prepare
WORKDIR "/root"
RUN apt-get update
RUN apt-get -y install wget
RUN apt-get -y install make

#install tsung 1.7.0
RUN apt-get -y install erlang gnuplot libtemplate-perl
RUN wget http://tsung.erlang-projects.org/dist/tsung-1.7.0.tar.gz
RUN tar zxvf tsung-1.7.0.tar.gz
RUN cd tsung-1.7.0 && ./configure && make && make install && make clean

#config ssh
RUN apt -y install ssh
RUN ssh-keygen -f /root/.ssh/id_rsa -N "" -t rsa
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN echo "LogLevel ERROR" >> /etc/ssh/ssh_config
RUN mkdir /var/run/sshd

#tune system
RUN echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf
RUN echo "net.ipv4.tcp_fin_timeout = 30" >> /etc/sysctl.conf
RUN echo "net.ipv4.ip_local_port_range = 1024 65000" >> /etc/sysctl.conf
RUN echo "fs.file-max = 65000" >> /etc/sysctl.conf
RUN echo "* soft nofile 65000" >> /etc/security/limits.conf
RUN echo "* hard nofile 65000" >> /etc/security/limits.conf

#clean
RUN apt-get clean
RUN rm -rf /root/*

#add script file
ADD runcontroler.sh /root/
ADD runclient.sh /root/

