FROM centos:7.3.1611

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ “/sys/fs/cgroup” ]

RUN yum -y install epel-release
RUN yum -y install file emacs wget bind fence-agents xinetd cobbler cobbler-web dhcp pykickstart

RUN cd /tmp && \
    wget http://ftp.es.debian.org/debian/pool/main/d/debmirror/debmirror_2.26.tar.xz && \
    tar xf debmirror* && \
    cp debmirror/debmirror /usr/bin && \
    rm -f /tmp/debmirror_2.26.tar.zx && \
    cd

# enable tftp
RUN sed -i '14s/.*/        disable                 = no /' /etc/xinetd.d/tftp

# create rsync file
RUN touch /etc/xinetd.d/rsync

RUN systemctl enable cobblerd httpd xinetd dhcpd rsyncd

EXPOSE 53
EXPOSE 69
EXPOSE 80
EXPOSE 443
EXPOSE 25151

CMD ["/sbin/init"]
