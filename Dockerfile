FROM docker.io/centos:centos6.6


RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-6 \
	&& rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6 \
	&& rpm --import https://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY



RUN rpm --rebuilddb \
	&& yum -y install \
	https://centos6.iuscommunity.org/ius-release.rpm \
	vim-minimal-7.4.629-5.el6 \
	sudo-1.8.6p3-20.el6_7 \
	openssh-5.3p1-112.el6_7 \
	openssh-server-5.3p1-112.el6_7 \
	openssh-clients-5.3p1-112.el6_7 \
	python-setuptools-0.6.10-3.el6 \
	vim-minimal \
	sudo \
	openssh \
	openssh-server \
	openssh-clients \
	python-setuptools \
	wget


RUN rm -rf /var/cache/yum/* && yum clean all




RUN wget http://dev.mysql.com/get/mysql57-community-release-el6-7.noarch.rpm



RUN rpm -ivh mysql57-community-release-el6-7.noarch.rpm



RUN yum -y install mysql-community-server.x86_64



RUN easy_install 'supervisor == 3.2.0' 'supervisor-stdout == 0.1.1' \
	&& mkdir -p /var/log/supervisor/






RUN sed -i \
	-e 's~^PasswordAuthentication yes~PasswordAuthentication no~g' \
	-e 's~^#PermitRootLogin yes~PermitRootLogin no~g' \
	-e 's~^#UseDNS yes~UseDNS no~g' \
	/etc/ssh/sshd_config






RUN sed -i 's~^# %wheel\tALL=(ALL)\tALL~%wheel\tALL=(ALL) ALL~g' /etc/sudoers




ADD etc/ssh-bootstrap /etc/
ADD etc/services-config/ssh/authorized_keys \
	etc/services-config/ssh/sshd_config \
	etc/services-config/ssh/ssh-bootstrap.conf \
	/etc/services-config/ssh/
ADD etc/services-config/supervisor/supervisord.conf /etc/services-config/supervisor/

RUN chmod 600 /etc/services-config/ssh/sshd_config \
	&& chmod +x /etc/ssh-bootstrap \
	&& ln -sf /etc/services-config/supervisor/supervisord.conf /etc/supervisord.conf \
	&& ln -sf /etc/services-config/ssh/sshd_config /etc/ssh/sshd_config \
	&& ln -sf /etc/services-config/ssh/ssh-bootstrap.conf /etc/ssh-bootstrap.conf










ENV SSH_AUTHORIZED_KEYS ""
ENV SSH_SUDO "ALL=(ALL) ALL"
ENV SSH_USER_PASSWORD ""
ENV SSH_USER "app-admin"
ENV SSH_USER_HOME_DIR "/home/app-admin"
ENV SSH_USER_SHELL "/bin/bash"




EXPOSE 22
EXPOSE 3306




CMD ["/usr/bin/supervisord", "--configuration=/etc/supervisord.conf"]
