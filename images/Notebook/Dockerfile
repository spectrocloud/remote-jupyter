FROM jupyter/scipy-notebook
USER root
RUN pip install remote_ipykernel
# Install sudo
RUN apt-get update && apt-get install -y sudo && apt-get clean

# Set sudoers
RUN echo "jovyan ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# change password for jovyan
#RUN echo "jovyan:jovyan" | chpasswd

COPY ./entrypoint.sh /entrypoint.sh
# entrypoint
RUN chmod +x /entrypoint.sh

#USER root
#USER jovyan
ENTRYPOINT ["/entrypoint.sh"]
