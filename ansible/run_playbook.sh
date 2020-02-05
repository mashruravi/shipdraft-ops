#! /bin/bash

ansible-playbook -i hosts --key-file ../shipdraft-ec2.pem -u ubuntu playbook.yml