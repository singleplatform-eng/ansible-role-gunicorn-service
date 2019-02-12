#!/bin/bash
#
# Ansible role test shim.
#
# Usage: [OPTIONS] ./tests/test.sh
#   - distro: a supported Docker distro version (default = "centos7")
#   - playbook: a playbook in the tests directory (default = "test.yml")
#   - cleanup: whether to remove the Docker container (default = true)
#   - container_id: the --name to set for the container (default = timestamp)

# Exit on any individual command failure.
set -e

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

timestamp=$(date +%s)

# Allow environment variables to override defaults.
distro=${distro:-"ubuntu1804"}
playbook=${playbook:-"test.yml"}
cleanup=${cleanup:-"true"}
container_id=${container_id:-$timestamp}

## Set up vars for Docker setup.
init="/lib/systemd/systemd"
opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"

# Run the container using the supplied OS.
printf ${green}"Starting Docker container: geerlingguy/docker-$distro-ansible."${neutral}"\n"
docker pull geerlingguy/docker-$distro-ansible:latest
docker run --detach --volume="$PWD":/etc/ansible/roles/role_under_test:rw --name $container_id $opts geerlingguy/docker-$distro-ansible:latest $init

printf "\n"

# Install requirements if `requirements.yml` is present.
if [ -f "$PWD/tests/requirements.yml" ]; then
  printf ${green}"Requirements file detected; installing dependencies."${neutral}"\n"
  docker exec --tty $container_id env TERM=xterm ansible-galaxy install -r /etc/ansible/roles/role_under_test/tests/requirements.yml
fi

printf "\n"

# Test Ansible syntax.
printf ${green}"Checking Ansible playbook syntax."${neutral}
docker exec --tty $container_id env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook --syntax-check

printf "\n"

# Run Ansible playbook.
printf ${green}"Running command: docker exec $container_id env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook"${neutral}
docker exec $container_id env TERM=xterm env ANSIBLE_FORCE_COLOR=1 ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook

# Run Ansible playbook again (idempotence test).
printf ${green}"Running playbook again: idempotence test"${neutral}
idempotence=$(mktemp)
docker exec $container_id ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook | tee -a $idempotence
tail $idempotence \
  | grep -q 'changed=0.*failed=0' \
  && (printf ${green}'Idempotence test: pass'${neutral}"\n") \
  || (printf ${red}'Idempotence test: fail'${neutral}"\n" && exit 1)


printf ${green}"Testing Start Handlers and Service\n"${neutral}
docker exec $container_id ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook -e 'test_handlers=True test_service=True'
printf ${green}"Handlers and Service test passed\n"${neutra}


# Remove the Docker container (if configured).
if [ "$cleanup" = true ]; then
  printf "Removing Docker container...\n"
  docker rm -f $container_id
fi
