#!/usr/bin/env bash

# Password for the 'elastic' user (at least 6 characters)
export ELASTIC_PASSWORD="long_word_for_access_to_elastic"
# Password for the 'kibana_system' user (at least 6 characters) - not used for access to GUI
export KIBANA_PASSWORD="long_word_for_access_to_kibana"
# Version of Elastic products
export STACK_VERSION=8.4.3
# Set the cluster name
export CLUSTER_NAME=my-elastic-cluster
# Set to 'basic' or 'trial' to automatically start the 30-day trial
export LICENSE=basic
# Port to expose Elasticsearch HTTP API to the host
export ES_PORT=9200
# Port to expose Kibana to the host
export KIBANA_PORT=5601
# Increase or decrease based on the available host memory (in bytes)
export MEM_LIMIT=1073741824
# Default value for ElasticSearch requirements - used by scripts to set system value
vm_max_map_count=262144

init_dir() {
    if [ ! -d "./$1" ]; then
        mkdir ./$1
    fi
    if [ $(stat -c '%a' ./$1 | cut -c2) -lt 7 ]; then
        chmod g+rwx $1
    fi
}

init() {
    chmod go-w ./config/filebeat.yml
    init_dir kibanadata
    init_dir esdata01
    init_dir esdata02
    cur_mmc=$(cat /proc/sys/vm/max_map_count)
    if [ $cur_mmc -lt $vm_max_map_count ]; then
        echo "In order to run ElasticSearch nodes 'vm.max_max_count' must be greater $vm_max_map_count"
        read -p "Enter you decision: [T]emporary, [P]ersistent or other to quit ? " decision
        case $decision in
            t | T)
                ;;
            p | P)
                echo vm.max_map_count=$vm_max_map_count | sudo tee -a /etc/sysctl.conf
                ;;
            *)
                echo "Abort operation and quit"
                return 2
                ;;
        esac
        echo "Change value $cur_mmc to $vm_max_map_count"
        echo $vm_max_map_count | sudo tee /proc/sys/vm/max_map_count
    fi
}

clear_dir() {
    if [ -d "./$1" ]; then
        rm -Rf $1
    fi
}

clear() {
    down
    clear_dir certs
    clear_dir esdata01
    clear_dir esdata02
    clear_dir kibanadata
}

up() {
    init
    if [ $? != 2 ]; then
        docker compose up -d
    fi
}

down() {
    if [[ -n $( docker ps -q -f name="es") ]]; then
        docker compose down
    fi
}

e() {
    if [ $1 ]; then
        docker exec -ti -u root es-$1 bash
    else
        list_containers
    fi
}

l() {
    if [ $1 ]; then
        docker logs es-$1 -f
    else
        list_containers
    fi
}

list_containers() {
    echo "Set container name from list: node-01 | node-02 | kibana | logstash | filebeat"
}

pull() {
    docker compose pull
}

if [ $1 ]; then
    $1 $2
else
    echo "Possible commands:"
    echo "  init - Init directory structure"
    echo "  pull - Load/Update docker images"
    echo "  up - Up containers"
    echo "  e <cnt> - Enter to container <cnt> as root user"
    echo "  l <cnt> - Print logs of container <cnt>"
    echo "  down - Down and remove containers"
    echo "  clear - Clear nodes and data"
fi
