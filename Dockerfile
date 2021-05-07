FROM debian

RUN apt-get update

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/'      /etc/ssh/sshd_config
RUN sed -ri 's/^#?LogLevel\s+.*/LogLevel VERBOSE/'               /etc/ssh/sshd_config
RUN sed -ri 's/^#?SyslogFacility\s+.*/SyslogFacility AUTHPRIV/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g'                       /etc/ssh/sshd_config
RUN mkdir /root/.ssh

RUN apt-get install -y rsyslog
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf # dont need kernel log

RUN apt-get clean && \
   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


EXPOSE 22
# Logging is not enabled by default, to enable it you must run:
# 	1. service ssh start ; 
# 	2. service rsyslog restart ;
# AFTER the CMD command below
CMD ["/usr/sbin/sshd", "-D"]
