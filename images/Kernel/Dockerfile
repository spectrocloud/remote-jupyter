FROM jupyter/scipy-notebook
USER root
# timezone
RUN apt update && apt install -y tzdata; \
    apt clean;

# sshd
RUN mkdir /var/run/sshd; \
    apt install -y openssh-server; \
    echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config; \
    apt clean;

# entrypoint
RUN { \
    echo '#!/bin/bash -eu'; \
    echo 'ssh-keygen -A'; \
    echo 'chmod 700 /home/jovyan/.ssh'; \
    echo 'chown -R jovyan:users /home/jovyan/.ssh'; \
    echo 'chmod 600 /home/jovyan/.ssh/authorized_keys'; \
    echo 'exec /usr/sbin/sshd -D -e'; \
    # Exec as jovyan
    #echo 'exec sudo -E -H -u jovyan bash -c "/usr/sbin/sshd -D -e"'; \
    } > /usr/local/bin/entry_point.sh; \
    chmod +x /usr/local/bin/entry_point.sh;

# Install sudo
RUN apt-get update && apt-get install -y sudo && apt-get clean

# Set sudoers
RUN echo "jovyan ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV TZ Europe/Rome

ENV ROOT_PASSWORD root

EXPOSE 22

ENTRYPOINT ["/usr/local/bin/entry_point.sh"]