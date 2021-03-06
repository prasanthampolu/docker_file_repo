#BASE IMAGE
FROM centos:7

#Maintainer details
MAINTAINER prasanth ampolu, prasanth.ampolu6@gmail.com

RUN yum install wget vim -y

# install yum repo
RUN rpm --import http://packages.gopivotal.com/pub/rpm/rhel7/app-suite/RPM-GPG-KEY-PIVOTAL-APP-SUITE-EL7

#enable configuration manager
RUN yum repolist all runyum install -y yum-utils
RUN yum clean all
RUN yum repolist enabled
RUN yum-config-manager --enable rhel-7-server-optional-rpms
RUN yum-config-manager --add-repo http://packages.pivotal.io/pub/rpm/rhel7/app-suite/x86_64

# install java, set JAVA_HOME
RUN cd ~
RUN wget -nv --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm"
RUN yum -y localinstall jdk-8u60-linux-x64.rpm
RUN rm jdk-*.rpm
ENV JAVA_HOME=/usr/java/jdk1.8.0_60/jre

# install tcserver
RUN yum install -y pivotal-tc-server-standard

# install tcserver instance prasanth_server
RUN mkdir -p /web/tcserver
RUN /opt/pivotal/pivotal-tc-server-standard/tcruntime-instance.sh create -i /web/tcserver prasanth_server

# add default manager.war
ADD jenkins.war /web/tcserver/prasanth_server/webapps


# start the tcserver instance
RUN /web/tcserver/prasanth_server/bin/tcruntime-ctl.sh start /web/tcserver/prasanth_server


# keep the container alive (PID=1)
CMD tail -f /web/tcserver/prasanth_server/logs/catalina.out

EXPOSE 9090 




