#!/usr/bin/env bash

workdir=./infrastructure

if ! [ -x "$(command -v terraform)" ]; then
  echo 'Terraform is not installed. Visit: https://hashicorp-releases.yandexcloud.net/terraform/' >&2
  exit 1
fi

if ! [ -x "$(command -v yc)" ]; then
  echo 'Yandex CLI is not installed. Visit: https://cloud.yandex.ru/docs/cli/quickstart' >&2
  exit 2
fi

if [ ! -f $workdir/main.tf ]; then
  echo "Infrastructure file not found"
  exit 3
fi

export TF_VAR_YC_TOKEN=$(yc config get token)
export TF_VAR_YC_CLOUD_ID=$(yc config get cloud-id)
export TF_VAR_YC_FOLDER_ID=$(yc config get folder-id)
export TF_VAR_YC_ZONE=$(yc config get compute-default-zone)

init() {
    terraform init
    ansible-galaxy collection install kubernetes.core
    pip3 install kubernetes
}

up() {
    terraform apply --auto-approve
    if [ $? -eq 0 ]; then
        ansible-playbook ../playbooks/dynamic_add.yml
        list
    else
        echo Init terraform first
    fi
}

down() {
    ansible-playbook ../playbooks/dynamic_rm.yml
    terraform destroy --auto-approve
}

clear() {
    rm -rf .terraform*
    rm terraform.tfstate*
}

deploy() {
    ansible-playbook ../playbooks/minikube.yml
    list
}

demo() {
    ansible-playbook ../playbooks/demo_minikube.yml
}

list() {
    yc compute instance list
}

if ! [ $workdir == "." ]; then
  if [ -d $workdir ]; then
    cd $workdir
  else
    echo "Can't access to Work directory"
    exit 4
  fi
fi

if [ $1 ]; then
    $1
else
    echo "Possible commands:"
    echo "  init - Init terraform provider"
    echo "  up - Deplay cloud resources"
    echo "  down - Destroy all cloud resources"
    echo "  clear - Clear temporary files"
    echo "  deploy - Deploy and start Minikube"
    echo "  demo - Pull demo sequence to minikube"
    echo "  list - Show Yandex Cloud instances"
fi
