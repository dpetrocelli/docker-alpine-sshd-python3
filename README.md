# Docker-alpine-sshd-python3
This is an alpine docker image prepared to be used with ansible (80 MB) or any other application that needs SSH service running on it.
Please feel free to modify based on your needs.

# Main features
* Code is well-documented to be easily read
* It includes the possibility to be run as sudo or non-sudo container Docker image (ARG settings) 
* SSH is configured to deny Root or user/password access 
* SSH is configured to use public server access keys (id_rsa.pub) 

# How this image could be run ?
To be able to run this image you need to follow the following steps:
* Clone this repository
* Generate your server keys (create_your_keys.sh). In our case is used by Ansible Server
* Build the docker image.

## Process Example
```bash
# Clone the repository
$ git clone https://github.com/dpetrocelli/docker-alpine-sshd-python3.git

# Build the Docker image
$ cd docker-alpine-sshd-python3
$ docker build . -t alpine-sshd-python:latest

# Run the container (mapping port 2222 on HOST)
docker run --rm --name alpine-sshd-python -p 2222:22 alpine-sshd-python:latest

# If you don't wanna keep your terminal blocked, you could run it in dettached mode
docker run -d --rm --name alpine-sshd-python -p 2222:22 alpine-sshd-python:latest

# now check everything is OK
docker ps 
CONTAINER ID   IMAGE                       COMMAND               CREATED          STATUS          PORTS                                   NAMES
018a9cda3bf2   alpine-sshd-python:latest   "/usr/sbin/sshd -D"   42 seconds ago   Up 41 seconds   0.0.0.0:2222->22/tcp, :::2222->22/tcp   alpine-sshd-python
```

## Now connect via SSH 
``` bash 
ssh -p 2222 -i id_rsa sshuser@localhost
...Are you sure you want to continue connecting (yes/no/[fingerprint])? yes

You are in :)

```
## Sudo or non-sudo permission
If you set ARG sudo_privileges="yes" in the Dockerfile, you will be able to run commands as sudo user. If ="no" the other way round.
