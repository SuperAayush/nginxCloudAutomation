- name: Install Ansible on the public instance using pip
  hosts: public_hosts
  become: true  # Use sudo to become root
  tasks:
    - name: Ensure pip is installed
      yum:
        name: python-pip
        state: present

    - name: Install Ansible via pip
      pip:
        name: ansible
        state: present

- name: Install Docker and Nginx on private instances
  hosts: private_hosts
  become: true
  vars:
    ansible_ssh_common_args: "-o ProxyCommand='ssh -W %h:%p -q -i ./tf_module/ssh/key_pair.pem ec2-user@${public_ip}'"
  tasks:
    - name: Install Docker
      yum:
        name: docker
        state: latest
      when: ansible_os_family == "RedHat"

    - name: Start and enable Docker
      systemd:
        name: docker
        enabled: true
        state: started

    - name: Install Nginx
      yum:
        name: nginx
        state: present

    - name: Start and enable Nginx
      systemd:
        name: nginx
        enabled: true
        state: started
