#! /bin/bash
installPackages () {
  sudo apt-get update -y
  sudo apt-get install ansible -y
}
installPackages