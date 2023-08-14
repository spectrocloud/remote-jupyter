# remote-jupyter

Container images to run Jupyter Notebooks and Kernels in separate containers.


## Usage

We first create an SSH key pair used from the Notebook to connect to the remote kernel:

```bash
# gen rsa key with docker without asking questions
docker run --user root -v $(pwd)/keys:/home/jovyan/.ssh --entrypoint /bin/bash --rm -ti quay.io/spectrocloud-labs/remote-jupyter:main-notebook -c "ssh-keygen -f /home/jovyan/.ssh/id_rsa -t rsa -b 4096 -Cci -N ''"
```

We can now start a kernel:

```bash
# start a kernel
docker run -v $(pwd)/keys/id_rsa.pub:/home/jovyan/.ssh/authorized_keys -p 2222:22 -d --name jupyter-kernel -ti quay.io/spectrocloud-labs/remote-jupyter:main-kernel
```

Now, write a ssh config to connect to the kernel.

This is needed because the kernel is running in a docker container locally, modify it as necessary:

```bash
cat << EOF > ssh_config
Host jupyter-kernel
    HostName 172.17.0.1
    Port 2222
    User jovyan
EOF
```

Now we can start the notebook that will use the remote kernel:

```bash
# start the notebook

docker run -p 8888:8888 \
        -v $(pwd)/keys:/home/jovyan/.ssh \
        -v $(pwd)/ssh_config:/home/jovyan/.ssh/config \
        --name jupyter-notebook \
        -v $(pwd):/home/jovyan/work \
        -e KERNEL_CMD="/opt/conda/bin/python -m ipykernel_launcher -f {connection_file}" \
        -e KERNEL_NAME="Remote Kernel Python3" \
        -e KERNEL_HOST="jovyan@jupyter-kernel" \
        -e KERNEL_WORKDIR="/home/jovyan/work" \
        -e KERNEL_LANGUAGE="python" \
        --rm -ti quay.io/spectrocloud-labs/remote-jupyter:main-notebook
```
