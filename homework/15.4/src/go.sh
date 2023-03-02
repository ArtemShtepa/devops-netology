#!/usr/bin/env bash

if ! [ -d "./terraform" ]; then
	echo "Source of terraform files not found"
	exit 3
fi

cd terraform

if ! [ -x "$(command -v terraform)" ]; then
	echo 'Terraform is not installed. Visit: https://hashicorp-releases.yandexcloud.net/terraform/' >&2
	exit 1
fi

if ! [ -x "$(command -v yc)" ]; then
	echo 'Yandex CLI is not installed. Visit: https://cloud.yandex.ru/docs/cli/quickstart' >&2
	exit 2
fi

export TF_VAR_YC_TOKEN=$(yc config get token)
export TF_VAR_YC_CLOUD_ID=$(yc config get cloud-id)
export TF_VAR_YC_FOLDER_ID=$(yc config get folder-id)
export TF_VAR_YC_ZONE=$(yc config get compute-default-zone)

init() {
	terraform init
}

up() {
	terraform apply --auto-approve
}

plan() {
	terraform plan
}

down() {
	terraform destroy --auto-approve
}

clear() {
	rm -rf .terraform*
	rm terraform.tfstate*
}

getkc() {
	yc managed-kubernetes cluster get-credentials kube-cluster --external --force
}

if [ $1 ]; then
	$1
else
	echo "Possible commands:"
	echo "  init - Init terraform provider"
	echo "  plan - Plan expected changes"
	echo "  getkc - Get Kube config"
	echo "  up - Deplay cloud resources"
	echo "  down - Destroy all cloud resources"
	echo "  clear - Clear temporary files"
fi
