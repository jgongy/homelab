# Ansible Playbook for Proxmox Setup

An Ansible playbook for bootstrapping a Proxmox installation after the initial
setup.

## Requirements
* `Python >= 3.13`
* SSH key access to Proxmox host(s) in `hosts.yaml`
* Root password for the machine running the playbook

## To run
```
ansible-playbook -i ansible/proxmox/hosts.yaml --ask-pass ansible/proxmox/bootstrap.yaml
```