# Домашнее задание по лекции "14.4 Сервис-аккаунты"

## Обязательная задача 1: Работа с сервис-аккаунтами через утилиту kubectl в установленном minikube

> Выполните приведённые команды в консоли. Получите вывод команд.
> Сохраните задачу 1 как справочный материал.

Вместо **minikube** был использован кластер из виртуальных машин

```console
root@debian11:~# kubectl get nodes
NAME    STATUS   ROLES           AGE   VERSION
node1   Ready    control-plane   6d    v1.26.1
node2   Ready    <none>          6d    v1.26.1
node3   Ready    <none>          6d    v1.26.1
root@debian11:~#
```

### Определение

Сервисный аккаунт - сущность **Kubernetes**, позволяющая предоставлять другим сущностям (приложениям/сервисам/людям)
доступ к **API Kubernetes** посредством своего токена в рамках установленных для конкретного сервисного аккаунта разрешений.
Каждый **namespace** содержит как нимимум один сервисный аккаунт **default**.

Для предоставления доступа пользователям, помимо создания сервисного аккаунта нужно:
  1. Создать роль - обычную (привяза к **namespace**) или кластерную (доступна всем **namespace**)
  1. Назначить роли необходимые права/разрешения
  1. Привязать сервисный аккаунт к роли
  1. Создать файл конифгурации с которым будет запускаться **kubectl**

Подробная инструкция по реализации доступа пользователя к кластеру: [hamnsk/k8s](https://github.com/hamnsk/k8s/blob/main/serviceaccount.md) - автор **Сергей Андрюнин**
> Применимо к версиям Kubernetes до 1.22, для более новых нужно добавлять **token** вручную

### Как создать сервис-аккаунт?

Один из способов создания сервисного аккаунта - командой **kubectl**: `kubectl create serviceaccount <name>`, где `<name>` - имя создаваемого сервисного аккаунта.

По умолчанию создаваемый сервисный аккаунт привязывается к текущему **namespace**.
Если нужно создать сервисный аккаунт в другом **namespace** достаточно сменить настройки
текущего контекста, либо добавить в команду ключ `--namespace <ns>` или `-n <ns>`,
где `<ns>` - имя **namespace**, где будет создан сервисный аккаунт

```console
root@debian11:~# kubectl create serviceaccount netology
serviceaccount/netology created
root@debian11:~# kubectl create sa netology -n sa-test
serviceaccount/netology created
root@debian11:~#
```

### Как просмотреть список сервис-акаунтов?

Для просмотра списка сервисных аккаунтов можно воспользоваться командой: `kubectl get serviceaccounts`

> В соответствии с `kubectl api-resources` ключевое слово `serviceaccount` можно заменить сокращением `sa`

```console
root@debian11:~# kubectl get sa
NAME                                SECRETS   AGE
default                             0         6d
netology                            0         2m20s
nfs-server-nfs-server-provisioner   0         16h
root@debian11:~# kubectl get sa -A | grep netology
default           netology                             0         2m31s
sa-test           netology                             0         2m19s
root@debian11:~#
```

### Как получить информацию в формате YAML и/или JSON?

Просмотр манифеста сущности сервисного аккаунт выполняется стандартным для **kubectl** способом: `describe` или `get` с ключами `--output` или `-o`

```console
root@debian11:~# kubectl describe sa default --namespace kube-system
Name:                default
Namespace:           kube-system
Labels:              <none>
Annotations:         <none>
Image pull secrets:  <none>
Mountable secrets:   <none>
Tokens:              <none>
Events:              <none>
root@debian11:~# kubectl get sa netology --output=json
{
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "creationTimestamp": "2023-02-18T12:49:27Z",
        "name": "netology",
        "namespace": "default",
        "resourceVersion": "98113",
        "uid": "3a8f0124-0580-499c-9d4a-a798788e52b2"
    }
}
root@debian11:~# kubectl get sa netology -n sa-test -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2023-02-18T12:49:39Z"
  name: netology
  namespace: sa-test
  resourceVersion: "98145"
  uid: 2ec80cca-16a0-4401-aa0a-af0e06b42bf2
root@debian11:~#
```

> При выводе с использованием `get` доступно два режима - вывод манифеста конкретного сервисного аккаунта (нужно указать его имя: `get <name>`) либо всех доступных (`get` без конкретизации)

В **Kubernetes** начиная с версии `1.22` постоянный токен для сервисного аккаунта автоматически не генерируется, что видно по логу выше.
Вместо этого используется новый механизм короткоживущих токенов [TokenRequest](https://kubernetes.io/docs/reference/kubernetes-api/authentication-resources/token-request-v1/).
Подробнее указано в [документации](https://kubernetes.io/docs/concepts/configuration/secret/#service-account-token-secrets)

Однако, создание постоянного токена всё ещё доступно - так в документации приведён соответствующий манифест, на основе которого подготовлен следующий:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: secret-for-netology
  namespace: sa-test
  annotations:
    kubernetes.io/service-account.name: "netology"
type: kubernetes.io/service-account-token
data:
  # Дополнительные записи ключ/значение
  extra: SGVsbG8gU2VyZ2V5IQo=
```

После применения манифеста:

```console
root@debian11:~/14.4# kubectl apply -f tkn_secret.yml
secret/secret-for-netology created
root@debian11:~/14.4# kubectl describe sa netology -n sa-test
Name:                netology
Namespace:           sa-test
Labels:              <none>
Annotations:         <none>
Image pull secrets:  <none>
Mountable secrets:   <none>
Tokens:              secret-for-netology
Events:              <none>
```

### Как выгрузить сервис-акаунты и сохранить его в файл?

Выгрузка манифеста сервисного аккаунта выполняется простым перенаправлением **stdout**

- Вывод сервисного аккаунта netology из текущего **namespace** (`default`) в файл `netology.yml` формата **YAML**: `kubectl get sa netology -o yaml > netology.yml`

- Вывод всех сервисных аккаунтов из **namespace** `sa-test` в файл `serviceaccounts.json` формата **JSON**: `kubectl get sa -n sa-test -o json > servicesaccounts.json`

### Как удалить сервис-акаунт?

Удаление сервисного аккаунта выполняется командой `kubectl delete sa <name>`, где `<name>` - имя удаляемого сервисного аккаунта

```console
root@debian11:~/14.4# kubectl delete serviceaccount netology
serviceaccount "netology" deleted
root@debian11:~/14.4#
```

### Как загрузить сервис-акаунт из файла?

Загрузка сервисного аккаунта из файла выполняется обычным применением файла манифеста: `kubectl apply -f <file>`, где `<file>` - имя файла манифеста сервисного аккаунта, который нужно загрузить

```console
root@debian11:~/14.4# kubectl apply -f netology.yml
serviceaccount/netology created
root@debian11:~/14.4#
```

## Дополнительная задача 2 (*): Работа с сервис-акаунтами внутри модуля

> Выбрать любимый образ контейнера, подключить сервис-акаунты и проверить доступность API Kubernetes

```console
root@debian11:~/14.4# kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
sh-5.2#
```

Просмотр переменных среды, которые пробрасывает **Kubernetes**

```console
sh-5.2# env | grep KUBE
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT_443_TCP=tcp://10.233.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_ADDR=10.233.0.1
KUBERNETES_SERVICE_HOST=10.233.0.1
KUBERNETES_PORT=tcp://10.233.0.1:443
KUBERNETES_PORT_443_TCP_PORT=443
sh-5.2#
```

Создание вспомогательных переменных

```
sh-5.2# K8S=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
sh-5.2# SADIR=/var/run/secrets/kubernetes.io/serviceaccount
sh-5.2# TOKEN=$(cat $SADIR/token)
sh-5.2# CACERT=$SADIR/ca.crt
sh-5.2# NAMESPACE=$(cat $SADIR/namespace)
```

Подключение к **Kubernetes** через **curl** запрос к его **API** серверу

```
sh-5.2# curl -H "Authorization: Bearer $TOKEN" --cacert $CACERT $K8S/api/v1/
{
  "kind": "APIResourceList",
  "groupVersion": "v1",
  "resources": [
    {
      "name": "bindings",
      "singularName": "",
      "namespaced": true,
      "kind": "Binding",
      "verbs": [
        "create"
      ]
    },
    {
      "name": "componentstatuses",
      "singularName": "",
      "namespaced": false,
      "kind": "ComponentStatus",
      "verbs": [
        "get",
        "list"
      ],
      "shortNames": [
        "cs"
      ]
    },
    {
      "name": "configmaps",
      "singularName": "",
      "namespaced": true,
      "kind": "ConfigMap",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "cm"
      ],
      "storageVersionHash": "qFsyl6wFWjQ="
    },
    {
      "name": "endpoints",
      "singularName": "",
      "namespaced": true,
      "kind": "Endpoints",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "ep"
      ],
      "storageVersionHash": "fWeeMqaN/OA="
    },
    {
      "name": "events",
      "singularName": "",
      "namespaced": true,
      "kind": "Event",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "ev"
      ],
      "storageVersionHash": "r2yiGXH7wu8="
    },
    {
      "name": "limitranges",
      "singularName": "",
      "namespaced": true,
      "kind": "LimitRange",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "limits"
      ],
      "storageVersionHash": "EBKMFVe6cwo="
    },
    {
      "name": "namespaces",
      "singularName": "",
      "namespaced": false,
      "kind": "Namespace",
      "verbs": [
        "create",
        "delete",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "ns"
      ],
      "storageVersionHash": "Q3oi5N2YM8M="
    },
    {
      "name": "namespaces/finalize",
      "singularName": "",
      "namespaced": false,
      "kind": "Namespace",
      "verbs": [
        "update"
      ]
    },
    {
      "name": "namespaces/status",
      "singularName": "",
      "namespaced": false,
      "kind": "Namespace",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "nodes",
      "singularName": "",
      "namespaced": false,
      "kind": "Node",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "no"
      ],
      "storageVersionHash": "XwShjMxG9Fs="
    },
    {
      "name": "nodes/proxy",
      "singularName": "",
      "namespaced": false,
      "kind": "NodeProxyOptions",
      "verbs": [
        "create",
        "delete",
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "nodes/status",
      "singularName": "",
      "namespaced": false,
      "kind": "Node",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "persistentvolumeclaims",
      "singularName": "",
      "namespaced": true,
      "kind": "PersistentVolumeClaim",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "pvc"
      ],
      "storageVersionHash": "QWTyNDq0dC4="
    },
    {
      "name": "persistentvolumeclaims/status",
      "singularName": "",
      "namespaced": true,
      "kind": "PersistentVolumeClaim",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "persistentvolumes",
      "singularName": "",
      "namespaced": false,
      "kind": "PersistentVolume",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "pv"
      ],
      "storageVersionHash": "HN/zwEC+JgM="
    },
    {
      "name": "persistentvolumes/status",
      "singularName": "",
      "namespaced": false,
      "kind": "PersistentVolume",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "pods",
      "singularName": "",
      "namespaced": true,
      "kind": "Pod",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "po"
      ],
      "categories": [
        "all"
      ],
      "storageVersionHash": "xPOwRZ+Yhw8="
    },
    {
      "name": "pods/attach",
      "singularName": "",
      "namespaced": true,
      "kind": "PodAttachOptions",
      "verbs": [
        "create",
        "get"
      ]
    },
    {
      "name": "pods/binding",
      "singularName": "",
      "namespaced": true,
      "kind": "Binding",
      "verbs": [
        "create"
      ]
    },
    {
      "name": "pods/ephemeralcontainers",
      "singularName": "",
      "namespaced": true,
      "kind": "Pod",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "pods/eviction",
      "singularName": "",
      "namespaced": true,
      "group": "policy",
      "version": "v1",
      "kind": "Eviction",
      "verbs": [
        "create"
      ]
    },
    {
      "name": "pods/exec",
      "singularName": "",
      "namespaced": true,
      "kind": "PodExecOptions",
      "verbs": [
        "create",
        "get"
      ]
    },
    {
      "name": "pods/log",
      "singularName": "",
      "namespaced": true,
      "kind": "Pod",
      "verbs": [
        "get"
      ]
    },
    {
      "name": "pods/portforward",
      "singularName": "",
      "namespaced": true,
      "kind": "PodPortForwardOptions",
      "verbs": [
        "create",
        "get"
      ]
    },
    {
      "name": "pods/proxy",
      "singularName": "",
      "namespaced": true,
      "kind": "PodProxyOptions",
      "verbs": [
        "create",
        "delete",
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "pods/status",
      "singularName": "",
      "namespaced": true,
      "kind": "Pod",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "podtemplates",
      "singularName": "",
      "namespaced": true,
      "kind": "PodTemplate",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "storageVersionHash": "LIXB2x4IFpk="
    },
    {
      "name": "replicationcontrollers",
      "singularName": "",
      "namespaced": true,
      "kind": "ReplicationController",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "rc"
      ],
      "categories": [
        "all"
      ],
      "storageVersionHash": "Jond2If31h0="
    },
    {
      "name": "replicationcontrollers/scale",
      "singularName": "",
      "namespaced": true,
      "group": "autoscaling",
      "version": "v1",
      "kind": "Scale",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "replicationcontrollers/status",
      "singularName": "",
      "namespaced": true,
      "kind": "ReplicationController",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "resourcequotas",
      "singularName": "",
      "namespaced": true,
      "kind": "ResourceQuota",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "quota"
      ],
      "storageVersionHash": "8uhSgffRX6w="
    },
    {
      "name": "resourcequotas/status",
      "singularName": "",
      "namespaced": true,
      "kind": "ResourceQuota",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "secrets",
      "singularName": "",
      "namespaced": true,
      "kind": "Secret",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "storageVersionHash": "S6u1pOWzb84="
    },
    {
      "name": "serviceaccounts",
      "singularName": "",
      "namespaced": true,
      "kind": "ServiceAccount",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "sa"
      ],
      "storageVersionHash": "pbx9ZvyFpBE="
    },
    {
      "name": "serviceaccounts/token",
      "singularName": "",
      "namespaced": true,
      "group": "authentication.k8s.io",
      "version": "v1",
      "kind": "TokenRequest",
      "verbs": [
        "create"
      ]
    },
    {
      "name": "services",
      "singularName": "",
      "namespaced": true,
      "kind": "Service",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "svc"
      ],
      "categories": [
        "all"
      ],
      "storageVersionHash": "0/CO1lhkEBI="
    },
    {
      "name": "services/proxy",
      "singularName": "",
      "namespaced": true,
      "kind": "ServiceProxyOptions",
      "verbs": [
        "create",
        "delete",
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "services/status",
      "singularName": "",
      "namespaced": true,
      "kind": "Service",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    }
  ]
}sh-5.2#
```

---

### Дополнительные материалы

Документация [Kubernetes: Service Accounts](https://kubernetes.io/docs/concepts/security/service-accounts/)

Документация [Kubernetes: Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)

Оператор PostgreSQL [PGO](https://github.com/CrunchyData/postgres-operator)

---

Получение имени долгоживущего токена из описания сервисного аккаунта `netology` из **namespace** `sa-test`:
```console
kubectl describe sa netology -n sa-test | grep 'Tokens' | awk '{ print $2 }'
```
или
```console
kubectl -n sa-test describe sa netology | grep 'Tokens' | rev | cut -d ' ' -f1 | rev
```

Получение самого долгоживущего токена из секрета сервисного аккаунта `netology` из **namespace** `sa-test`:
```console
kubectl describe secret -n sa-test $(kubectl describe sa netology -n sa-test | grep 'Tokens' | awk '{ print $3 }') | grep 'token:' | awk '{ print $2 }'
```
либо имея имя секрета
```console
kubectl describe secrets $TOKEN_NAME -n sa-test | grep 'token:' | rev | cut -d ' ' -f1 | rev
```
