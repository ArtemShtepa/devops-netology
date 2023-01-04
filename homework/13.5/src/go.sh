#!/usr/bin/env bash

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
	if ! [ -d "kubespray" ]; then
		git clone https://github.com/kubernetes-sigs/kubespray
		pip3 install -r kubespray/requirements.txt
		cp -rfp kubespray/inventory/sample kubespray/inventory/mycluster
	fi
}

up() {
	terraform apply --auto-approve
	ansible-playbook playbooks/dynamic_add.yml
	yc compute instance list
	echo "Commands to configure Kubespray (inside kubespray dir):"
	echo "  declare -a IPS=(maste_ip ... worker_ip ...)"
	echo "  CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py \${IPS[@]}"
	echo "Manage nodes in inventory/_sample_/hosts.yaml, where _sample_ is your inventory dir."
	echo "Don't forget to add Master Node IP address to 'supplementary_addresses_in_ssl_keys'"
	echo "  list of file 'group_vars/k8s_cluster/k8s-cluster.yml'"
}

deploy() {
	cd kubespray
	ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -b
	cd ..
	getconfig
}

getconfig() {
	ansible-playbook -i kubespray/inventory/mycluster/hosts.yaml playbooks/get-config.yml
	chmod 600 ~/.kube/_config*
	yc compute instance list
}

nfs() {
	echo "--- Add helm repo ---"
	helm repo add stable https://charts.helm.sh/stable && helm repo update
	echo "--- Install NFS-common package ---"
	ansible-playbook -i kubespray/inventory/mycluster/hosts.yaml playbooks/install-nfs-common.yml
	echo "--- Install NFS server provisioner ---"
	helm upgrade --install nfs-server stable/nfs-server-provisioner
}

down() {
	ansible-playbook playbooks/dynamic_rm.yml
	terraform destroy --auto-approve
}

clear() {
	rm -rf .terraform*
	rm terraform.tfstate*
	if [ -d kubespray ]; then
		rm -rf kubespray
	fi
}

if [ $1 ]; then
	$1
else
	echo "Possible commands:"
	echo "  init - Init terraform provider"
	echo "  up - Deplay cloud resources"
	echo "  deploy - Configure cluster by Kubespray"
	echo "  getconfig - Get admin config from control plane"
	echo "  nfs - Deploy NFS server on cluster"
	echo "  down - Destroy all cloud resources"
	echo "  clear - Clear temporary files"
fi
