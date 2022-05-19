FROM ubuntu:20.04

ARG ssh_prv_key
ARG ssh_pub_key

RUN apt-get update && \
    apt-get install -y \
        openssh-server \
        ansible

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

WORKDIR /opt/app/

COPY ./inventory/ppl /opt/app/inventory
COPY ./ansible.cfg /etc/ansible/ansible.cfg

# CMD ["ansible", "--version"]
CMD [ "ansible", "all", "-m ping" ]
# CMD ["ls", "-la", "/etc/ansible/"]
# CMD ["cat", "/etc/ansible/ansible.cfg"]
# CMD ["cat", "/etc/ansible/hosts"]
# CMD ["cat", "/root/.ssh/id_rsa"]
# CMD ["nginx"]