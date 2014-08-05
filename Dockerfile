FROM debian:wheezy
MAINTAINER Ahmet Demir <ahmet2mir+github@gmail.com>

ENV RELEASE wheezy
ENV DEBIAN_FRONTEND noninteractive
ENV SHELL /bin/bash

# Change sources.list to point on mirrors
RUN echo "deb http://ftp.fr.debian.org/debian $RELEASE main contrib non-free" > /etc/apt/sources.list;\
	echo "deb http://ftp.debian.org/debian/ $RELEASE-updates main contrib non-free" >> /etc/apt/sources.list;\
	echo "deb http://security.debian.org/ $RELEASE/updates main contrib non-free" >> /etc/apt/sources.list

# "Update Repo"
RUN apt-get update
RUN apt-get install -y apt-utils

# "Runit"
RUN apt-get install -y runit
CMD /usr/sbin/runsvdir-start

# Utilities"
RUN apt-get install -y vim less net-tools inetutils-ping curl git telnet nmap socat\
    dnsutils netcat tree htop unzip sudo wget python-pip tmux cron sudo

# Adding files
ADD . /docker

# Install and configure SSH access for docker user
RUN apt-get install -y openssh-server

RUN mkdir -p /var/run/sshd

RUN useradd --create-home -s /bin/bash docker;\
	mkdir -p /home/docker/.ssh;\
	echo -n 'docker:docker' | chpasswd;\
	cat /docker/ssh/docker_rsa.pub >> /home/docker/.ssh/authorized_keys;\
	echo "" >> /home/docker/.ssh/authorized_keys;\
	chown -R docker: /home/docker/.ssh;\
	chmod 700 /home/docker/.ssh;\
	chmod 600 /home/docker/.ssh/authorized_keys

RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config;\
	sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

RUN mkdir -p /etc/sudoers.d;\
	echo "docker ALL= NOPASSWD: ALL" > /etc/sudoers.d/docker;\
	chmod 0440 /etc/sudoers.d/docker

# "Configure services"
# Based on https://github.com/mingfang/docker-salt
RUN for dir in /docker/services/*;\
    do echo $dir; chmod +x $dir/run $dir/log/run;\
    ln -sf $dir /etc/service/; done

# Expose services
EXPOSE 22


