FROM jenkins:latest
MAINTAINER Ryan Kortmann "ryankortmann@gmail.com"

USER jenkins

# install plugins
COPY plugins.txt /usr/share/jenkins/ref/
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

USER root

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

# Move over ssh  keys
COPY ssh_configs/ /root/.ssh/

COPY reload_configs.sh /tmp/

# Permissions for Jenkins user
RUN chown jenkins /tmp/reload_configs.sh
RUN chmod +x /tmp/reload_configs.sh

RUN chmod 600 /root/.ssh/id_rsa
RUN chmod 644 /root/.ssh/id_rsa.pub

# RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

# copy over configs
COPY scm-sync-configuration.xml /usr/share/jenkins/ref/

# checkout scm sync repo
RUN mkdir /usr/share/jenkins/ref/scm-sync-configuration/
RUN mkdir /usr/share/jenkins/ref/scm-sync-configuration/checkoutConfiguration/
RUN git clone git@github.com:jumpinghooligans/gspotsyncer-jenkins.git /usr/share/jenkins/ref/scm-sync-configuration/checkoutConfiguration/

USER jenkins

COPY reload.groovy /var/jenkins_home/init.groovy.d/

# disable setup
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false"