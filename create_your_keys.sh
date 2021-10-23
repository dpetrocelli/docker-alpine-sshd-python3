#!/bin/bash

# This will create your id_rsa and id_rsa.pub keyfiles. Based on this files, you will be able to connect to Docker Alpine image remotely
# without being asked for a password.
ssh-keygen -f id_rsa -t rsa -N ''

# In this specific case, is going to be used for Ansible playbooks tests.
