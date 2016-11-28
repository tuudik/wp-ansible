# PD development test task
## Environment description ##
**Control Machine:** Macbook Pro with macOS Sierra 10.12.1
**Provisioning cloud service:** [DigitalOcean](https://www.digitalocean.com) through APIv2
**Web application:** [WordPress 4.6.1](https://wordpress.org) with [WP-CLI](https://wp-cli.org)
**Tool for automation:** [Ansible 2.2.0.0](http://docs.ansible.com/ansible/index.html)
**Tool for testing:** [Small bash script](test.sh)
**Remote machine:** Ubuntu 14.04.05 x64

### Dependencies ###
 - [Homebrew](http://brew.sh) to install Python 2.7 (PS! Python can be also installed also just by downloading the "pkg" from Python website)
 - [Python 2.7](https://www.python.org) 
 - PIP - Python Package Manager, to install Ansible
 - dopy (DigitalOcean API Python Wrapper)
 - SSH key (Ansible Playbook will automatically generate one if missing)

## Preparation ##
### Installing Ansible (with dopy) on macOS ###
#### 1. Install Homebrew ####
To install Homebrew launch the command below in Terminal:

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#### 2. Install Python ####
To install Python 2.7 launch the command below in Terminal:

    brew install python
#### 3. Install PIP ####
To instal Python Package Manager PIP and update it, launch the commands below:

    sudo easy_install pip
    sudo pip install --upgrade pip
#### 4. Install Ansible and dopy ####
To install Ansible and dopy launch the following commands in Terminal:

    sudo pip install ansible
    sudo pip install dopy
#### 5. Make configuration files for Ansible ####
##### 5.1 Create configuration folder #####
    sudo mkdir /etc/ansible && cd /usr/local/etc/ansible
##### 5.2 Create /etc/ansible/ansible.cfg #####
    sudo vim /etc/ansible/ansible.cfg
We want Ansible to use particular hosts file so the content should be:
    [defaults]
    hostfile = hosts
##### 5.3 Create /etc/ansible/hosts #####
    sudo vim /etc/ansible/hosts
To run ansible locally since we cannot run the commands from the beginnning from remote machine, we need to define it like this:
    [digitalocean]
    localhost ansible_connection=local ansible_python_interpreter=python
### Generate DigitalOcean Personal Access Token to use APIv2 ###
To use DigitalOcean APIv2, it's neccessary to have existing Personal Access Token that will be used later in Ansible Playbook.

For generating DO Personal Access Token:
1. Log in to your DigitalOcean Account,
2. Select "API" from the main menu,
3. Click on "Generate New Token",
4. Write Token name, ie "ansible",
5. Make sure that both, "Read" and "Write" are checked,
6. Click "Generate Token"
7. Copy the Token somehwere safe and where you have access to, it won't be shown again, security measures.
    
### Clone repository ###
This can be done simply by running command below:
    git clone https://github.com/tuudik/wp-ansible.git

## Ansible playbook ##

This Ansible playbook will do the following:
1. Create Droplet in DigitalOcean
2. Setup LAMP stack in Droplet
3. Install WP-CLI and then WordPress by using WP-CLI
4. Test the installation and save the report by default into playbook directory
5. Delete Droplet from DigitalOcean

### Test ###
The test is pretty simple [bash](test.sh) script that will check that webadmin login is accessible and logging into webadmin works.

## Structure of this Ansible playbook ##
This Ansible playbook is divided into roles, there are 7 different roles:
- create_droplet - This is for creating Droplet in DigitalOcean
- delete_droplet - This is for deleting Droplet in DigitalOcean
- mysql - This is for setting up MySQL in Droplet
- php - This is for setting up PHP in Droplet
- server - This is for updating APT cache and install LAMP using APT and also clears the www directory
- test - This is where the testing is done
- wordpress - This is for installing WP-CLI for installing and setting up WordPress

All playbook files are commented for easier understanding.

The structure of this ansible playbook is as following:
```
main_playbook.yml
test.sh
README.md
groups_vars
|-all.yml
roles
|-create_droplet
 |-tasks
    |-main.yml
|-delete_droplet
  |-tasks
    |-main.yml
|-mysql
  |-tasks
    |-main.yml
|-php
  |-tasks
    |-main.yml
|-server
  |-tasks
    |-main.yml
|-test
  |-tasks
    |-main.yml
|-wordpress
  |-tasks
    |-main.yml
  |-handles
    |-main.yml
```

### Configuration in Ansible playbook ###
After cloning repository, it's neccessary that you checked the configuration [here](group_vars/all.yml) and make the neccessary changes atleast for following:
    # DigitalOcean configuration, specify token here:
    do_token: YOUR_TOKEN_HERE
    # SSH key to use for connecting to DigitalOcean Droplet, if SSH key doesn't exist, Ansible will create one
    ssh_key: 'YOUR_SSH_KEY_LOCATION'

### Running ansible playbook ###
To run Ansible playbook launch following command in playbook directory:
    ansible-playbook main_playbook.yml

#### Test results ####
Test results are saved by default into playbook directory, this can be changed when modifying [group_vars/all.yml](group_vars/all.yml) following line:
    result_file_loc: "{{ playbook_dir }}/result-{{ ansible_date_time.iso8601 }}.txt"
