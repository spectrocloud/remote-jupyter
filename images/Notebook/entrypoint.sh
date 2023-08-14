#!/bin/bash -eu

chmod 600 /home/jovyan/.ssh/id_rsa
chmod 700 /home/jovyan/.ssh
chown -R jovyan:users /home/jovyan/.ssh

su -l jovyan -c "PATH=/opt/conda/bin:/opt/conda/condabin:/opt/conda/bin:$PATH remote_ipykernel --add \
    --kernel_cmd=\"$KERNEL_CMD\" \
    --name=\"$KERNEL_NAME\" --interface=ssh \
    --host=\"$KERNEL_HOST\" --workdir=\"$KERNEL_WORKDIR\" --language=\"$KERNEL_LANGUAGE\""

su -l jovyan -c 'PATH=/opt/conda/bin:/opt/conda/condabin:/opt/conda/bin:$PATH tini -g -- /usr/local/bin/start.sh /usr/local/bin/start-notebook.sh'
