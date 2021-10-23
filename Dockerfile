# [STEP 0] - Specify alpine version
FROM alpine:3.14

# [STEP 1] - update apk repos and add needed dependencies
# Shadow package includes PAM-using login and passwd utilities
RUN apk update && \
apk add --no-cache openssh bash openssh shadow python3 py3-pip sudo

# [STEP 2] - Set configuration parameters
    
ARG username=sshuser
    ## username to be used for login
    
ARG pwd=$(uuidgen)
    ## Not having a password set for root prevents the public key authentication 
    ## from succeeding when trying to ssh on root or non-root account. 
    ## Because of this, we create a random pwd to be assigned to the sshuser

ARG sudo_privileges="yes"
    ## * yes, user could be gain sudo privileges
    ## * no, non-sudo permissions

RUN sed -i "s/.*PermitRootLogin.*/PermitRootLogin no/g" /etc/ssh/sshd_config && \ 
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    ## Prevent SSH for:
    ##   * root access  
    ##   * Password login

# [STEP 3] - Configure SSH service, it includes:
    ##  * SSH needed keys (alpine)
    ##  * add user (username parameter)
    ##  * check and assign user privileges
    ##  * Copy public server access keys (id_rsa.pub) and configure for username 
    ##    (This keys has been created before and must be stored in the same folder)
    ##    (example: ssh-keygen -f id_rsa -t rsa -N '')

RUN ssh-keygen -A && \
    useradd -m -s /bin/bash $username && \
    if [ $sudo_privileges = yes ] ; then addgroup --system sudo && usermod -aG sudo $username && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && touch /home/$username/.sudo_as_admin_successful ; fi && \
    echo "sshuser:$pwd" |chpasswd && \
    mkdir /home/sshuser/.ssh && \
    chmod 0700 /home/sshuser/.ssh

COPY id_rsa.pub /home/sshuser/.ssh/authorized_keys

RUN chown -R sshuser:sshuser /home/sshuser/.ssh && \
    chmod 600 /home/sshuser/.ssh/authorized_keys

# [STEP 4] - expose port 22 and start SSH service:

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
