# Домашнее задание по лекции "13.3 работа с kubectl"

## Исходное состояние кластера

В решении заданий использовалась инфраструктура, созданная в предыдущем решении [13.2](https://github.com/ArtemShtepa/devops-netology/tree/homework-13.2/homework/13.2).
На инфраструктуре применены **Kubernetes** манифесты из каталога [manifests](./manifests).

Список **pods** из **namespace** `production`:

```console
root@debian11:~/13.3# kubectl get pods -o wide
NAME                        READY   STATUS    RESTARTS   AGE   IP             NODE    NOMINATED NODE   READINESS GATES
backend-7b4f6699f5-c4d8f    1/1     Running   0          23m   10.233.71.3    node3   <none>           <none>
db-0                        1/1     Running   0          23m   10.233.75.5    node2   <none>           <none>
frontend-66d8f6d749-5lmnr   1/1     Running   0          23m   10.233.74.69   node4   <none>           <none>
root@debian11:~/13.3#
```

Созданные **services**:

```console
root@debian11:~/13.3# kubectl get svc
NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
backend-svc    ClusterIP   10.233.55.197   <none>        9000/TCP   24m
db-svc         ClusterIP   10.233.37.218   <none>        5432/TCP   24m
frontend-svc   ClusterIP   10.233.11.231   <none>        8000/TCP   24m
root@debian11:~/13.3#
```

### Описание **pod** **frontend**

```console
root@debian11:~/13.3# kubectl describe pods/frontend-66d8f6d749-5lmnr
Name:             frontend-66d8f6d749-5lmnr
Namespace:        production
Priority:         0
Service Account:  default
Node:             node4/10.2.0.13
Start Time:       Mon, 02 Jan 2023 18:48:02 -0500
Labels:           app=frontend
                  pod-template-hash=66d8f6d749
Annotations:      cni.projectcalico.org/containerID: 159c2295fcc00de4ebb095b7ff81743d3851d0e4ac40badb032642c96ae40722
                  cni.projectcalico.org/podIP: 10.233.74.69/32
                  cni.projectcalico.org/podIPs: 10.233.74.69/32
Status:           Running
IP:               10.233.74.69
IPs:
  IP:           10.233.74.69
Controlled By:  ReplicaSet/frontend-66d8f6d749
Containers:
  frontend:
    Container ID:   containerd://bca98b8d975d96b4b6590079b8dd4d493b430773b7afcb8a5276ed4bf08e0165
    Image:          artemshtepa/netology-app:frontend
    Image ID:       docker.io/artemshtepa/netology-app@sha256:d9599188343850f2af33d4ea0857819f8aea0f31165c6e48c0a8da9baf9e2a71
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 02 Jan 2023 18:48:20 -0500
    Ready:          True
    Restart Count:  0
    Environment:
      BASE_URL:  http://backend-svc:9000
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-qg58b (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-qg58b:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  39m   default-scheduler  Successfully assigned production/frontend-66d8f6d749-5lmnr to node4
  Normal  Pulling    39m   kubelet            Pulling image "artemshtepa/netology-app:frontend"
  Normal  Pulled     39m   kubelet            Successfully pulled image "artemshtepa/netology-app:frontend" in 14.310203307s
  Normal  Created    39m   kubelet            Created container frontend
  Normal  Started    39m   kubelet            Started container frontend
root@debian11:~/13.3# kubectl describe svc frontend-svc
Name:              frontend-svc
Namespace:         production
Labels:            <none>
Annotations:       <none>
Selector:          app=frontend
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.233.11.231
IPs:               10.233.11.231
Port:              frontend-port  8000/TCP
TargetPort:        80/TCP
Endpoints:         10.233.74.69:80
Session Affinity:  None
Events:            <none>
root@debian11:~/13.3#
```

### Описание **pod** **backend**

```console
root@debian11:~/13.3# kubectl describe pods/backend-7b4f6699f5-c4d8f
Name:             backend-7b4f6699f5-c4d8f
Namespace:        production
Priority:         0
Service Account:  default
Node:             node3/10.2.0.29
Start Time:       Mon, 02 Jan 2023 18:48:05 -0500
Labels:           app=backend
                  pod-template-hash=7b4f6699f5
Annotations:      cni.projectcalico.org/containerID: 28a5a559481d239e7d18e864d5f26f77b3f7326b9619c9c2b852fb26b723d7e6
                  cni.projectcalico.org/podIP: 10.233.71.3/32
                  cni.projectcalico.org/podIPs: 10.233.71.3/32
Status:           Running
IP:               10.233.71.3
IPs:
  IP:           10.233.71.3
Controlled By:  ReplicaSet/backend-7b4f6699f5
Containers:
  backend:
    Container ID:   containerd://3ad0adc3dd61984cc317b2962bfb7ffa0896e22a3cb816c41f061b7d3735262c
    Image:          artemshtepa/netology-app:backend
    Image ID:       docker.io/artemshtepa/netology-app@sha256:de7388f1f95a8c4b9562ab75550c6ffc7efd7e1f243cb8bac1104332237b42c0
    Port:           9000/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 02 Jan 2023 18:49:35 -0500
    Ready:          True
    Restart Count:  0
    Environment:
      DATABASE_URL:  postgresql://postgres:postgres@db-svc:5432/news
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-jhl6d (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-jhl6d:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  40m   default-scheduler  Successfully assigned production/backend-7b4f6699f5-c4d8f to node3
  Normal  Pulling    40m   kubelet            Pulling image "artemshtepa/netology-app:backend"
  Normal  Pulled     39m   kubelet            Successfully pulled image "artemshtepa/netology-app:backend" in 1m19.959151837s
  Normal  Created    39m   kubelet            Created container backend
  Normal  Started    39m   kubelet            Started container backend
root@debian11:~/13.3# kubectl describe svc backend-svc
Name:              backend-svc
Namespace:         production
Labels:            <none>
Annotations:       <none>
Selector:          app=backend
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.233.55.197
IPs:               10.233.55.197
Port:              backend-port  9000/TCP
TargetPort:        9000/TCP
Endpoints:         10.233.71.3:9000
Session Affinity:  None
Events:            <none>
root@debian11:~/13.3#
```

### Описание базы данных (**statefulset**)

```console
root@debian11:~/13.3# kubectl describe pods/db-0
Name:             db-0
Namespace:        production
Priority:         0
Service Account:  default
Node:             node2/10.2.0.8
Start Time:       Mon, 02 Jan 2023 18:47:56 -0500
Labels:           app=db
                  controller-revision-hash=db-79d6745c9f
                  statefulset.kubernetes.io/pod-name=db-0
Annotations:      cni.projectcalico.org/containerID: a1c58756e83afecc61d2706579855cebe57229d92f05ced3fff457436d1ec56f
                  cni.projectcalico.org/podIP: 10.233.75.5/32
                  cni.projectcalico.org/podIPs: 10.233.75.5/32
Status:           Running
IP:               10.233.75.5
IPs:
  IP:           10.233.75.5
Controlled By:  StatefulSet/db
Containers:
  db:
    Container ID:   containerd://5f217fdf406b7c19e823a6d1bdac35e89524ad4b348269a5070fcf1749c33bda
    Image:          postgres:13-alpine
    Image ID:       docker.io/library/postgres@sha256:93924d8dbf68fef91ed3252a956a0668a609fc8a6693c7e4a519b0cca71b9203
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Mon, 02 Jan 2023 18:48:19 -0500
    Ready:          True
    Restart Count:  0
    Environment:
      POSTGRES_USER:      postgres
      POSTGRES_PASSWORD:  postgres
      POSTGRES_DB:        news
    Mounts:
      /var/lib/postgresql/data from db-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-j99pb (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  db-volume:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  db-pvc
    ReadOnly:   false
  kube-api-access-j99pb:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  42m   default-scheduler  0/4 nodes are available: 4 persistentvolumeclaim "db-pvc" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
  Normal   Scheduled         42m   default-scheduler  Successfully assigned production/db-0 to node2
  Normal   Pulling           42m   kubelet            Pulling image "postgres:13-alpine"
  Normal   Pulled            42m   kubelet            Successfully pulled image "postgres:13-alpine" in 20.869349006s
  Normal   Created           42m   kubelet            Created container db
  Normal   Started           42m   kubelet            Started container db
root@debian11:~/13.3# kubectl describe svc db-svc
Name:              db-svc
Namespace:         production
Labels:            <none>
Annotations:       <none>
Selector:          app=db
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.233.37.218
IPs:               10.233.37.218
Port:              db  5432/TCP
TargetPort:        5432/TCP
Endpoints:         10.233.75.5:5432
Session Affinity:  None
Events:            <none>
root@debian11:~/13.3#
```

## Задание 1: проверить работоспособность каждого компонента

> Для проверки работы можно использовать 2 способа: `port-forward` и `exec`.
> Используя оба способа, проверьте каждый компонент:
> * сделайте запросы к бекенду;
> * сделайте запросы к фронту;
> * подключитесь к базе данных.

### Запрос данных с **frontend**

Отправка запроса к **frontend** при помощи `exec`.
Запрос будет выполняеться из **pod** **backend** с использованием сервиса **frontend-svc**.

```console
root@debian11:~/13.3# kubectl exec backend-7b4f6699f5-c4d8f -- curl -s http://frontend-svc:8000 && echo
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>
root@debian11:~/13.3#
```

Открытие **port-forward** к **frontend** в отдельном терминале:

```console
root@debian11:~/13.3# kubectl port-forward svc/frontend-svc 8080:8000
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
Handling connection for 8080
```

Отправка запроса к **frontend** через **port-forward**

```console
root@debian11:~/13.3# curl 127.1:8080 && echo
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>
root@debian11:~/13.3#
```

### Запрос данных с **backend**

Отправка запроса к **backend** при помощи `exec`.
Запрос будет выполняеться из **pod** **frontend** с использованием сервиса **backend-svc**.

```console
root@debian11:~/13.3# kubectl exec frontend-66d8f6d749-5lmnr -- curl -s http://backend-svc:9000/api/news/ && echo
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}]
root@debian11:~/13.3#
```

Открытие **port-forward** к **backend** в отдельном терминале:

```console
root@debian11:~/13.3# kubectl port-forward svc/backend-svc 9090:9000
Forwarding from 127.0.0.1:9090 -> 9000
Forwarding from [::1]:9090 -> 9000
Handling connection for 9090
```

Отправка запроса к **backend** через **port-forward**

```console
root@debian11:~/13.3# curl 127.1:9090/api/news/ && echo
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}]
root@debian11:~/13.3#
```

### Запрос к базе данных

Подключение к базе данных, выполняя команду через `exec` непосредственно в **pod**.

> Для работы потребуется интерактивный режим, поэтому к команде добавлены флаги `-t` и `-i`.
> В **pod** будет выполнена команда подключения к базе данных и запрос списка существующих таблиц в базе **news**.

```console
root@debian11:~/13.3# kubectl exec -ti db-0 -- bash -c "psql postgresql://postgres:postgres@127.1:5432/news"
psql (13.9)
Type "help" for help.

news=# \d
             List of relations
 Schema |    Name     |   Type   |  Owner
--------+-------------+----------+----------
 public | news        | table    | postgres
 public | news_id_seq | sequence | postgres
(2 rows)

news=# \q
root@debian11:~/13.3#
```

Проброс порта базы данных на локальную машину (в отдельном терминале)

```console
root@debian11:~/13.3# kubectl port-forward svc/db-svc 9009:5432
Forwarding from 127.0.0.1:9009 -> 5432
Forwarding from [::1]:9009 -> 5432
Handling connection for 9009
```

Подключение к базе и запрос списка таблиц.

> Так как клиент **PostgreSQL** на локальной машине не установлен используется сборка клиента в виде [Docker образа](https://hub.docker.com/_/postgres)

```console
root@debian11:~/13.3# docker run -ti --rm --network=host --entrypoint=/bin/bash postgres:alpine -c "psql postgresql://postgres:postgres@127.1:9009/news"
Unable to find image 'postgres:alpine' locally
alpine: Pulling from library/postgres
c158987b0551: Already exists
534a27978278: Already exists
f9d52041f541: Already exists
74b70c010a5d: Pull complete
e7875b5f9f8f: Pull complete
3467b83dcb17: Pull complete
a712bfa9fd1a: Pull complete
77bebd9e7449: Pull complete
Digest: sha256:07c3361c9e8e1d734dfc51e239327b11d25196347be630fbdc556ca41f219184
Status: Downloaded newer image for postgres:alpine
psql (15.1, server 13.9)
Type "help" for help.

news=# \d
             List of relations
 Schema |    Name     |   Type   |  Owner
--------+-------------+----------+----------
 public | news        | table    | postgres
 public | news_id_seq | sequence | postgres
(2 rows)

news=# \q
root@debian11:~/13.3#
```

---

## Задание 2: ручное масштабирование

> При работе с приложением иногда может потребоваться вручную добавить пару копий.
> Используя команду `kubectl scale`, попробуйте увеличить количество бекенда и фронта до `3`.
> Проверьте, на каких нодах оказались копии после каждого действия (`kubectl describe`, `kubectl get pods -o wide`).
> После уменьшите количество копий до `1`.

Исходное состояние **pods**:

```console
root@debian11:~/13.3# kubectl get pods -o wide
NAME                        READY   STATUS    RESTARTS   AGE   IP             NODE    NOMINATED NODE   READINESS GATES
backend-7b4f6699f5-c4d8f    1/1     Running   0          60m   10.233.71.3    node3   <none>           <none>
db-0                        1/1     Running   0          60m   10.233.75.5    node2   <none>           <none>
frontend-66d8f6d749-5lmnr   1/1     Running   0          60m   10.233.74.69   node4   <none>           <none>
root@debian11:~/13.3#
```

Масштабирование **frontend** и **backend**, выполненное командой `scale`:

```console
root@debian11:~/13.3# kubectl scale --replicas=3 deploy/frontend
deployment.apps/frontend scaled
root@debian11:~/13.3# kubectl scale --replicas=3 deploy/backend
deployment.apps/backend scaled
root@debian11:~/13.3#
```

Состояние после масштабирования:

```console
root@debian11:~/13.3# kubectl get pods -o wide
NAME                        READY   STATUS    RESTARTS   AGE   IP             NODE    NOMINATED NODE   READINESS GATES
backend-7b4f6699f5-c4d8f    1/1     Running   0          64m   10.233.71.3    node3   <none>           <none>
backend-7b4f6699f5-l5t8f    1/1     Running   0          73s   10.233.75.7    node2   <none>           <none>
backend-7b4f6699f5-zkdjg    1/1     Running   0          73s   10.233.74.70   node4   <none>           <none>
db-0                        1/1     Running   0          64m   10.233.75.5    node2   <none>           <none>
frontend-66d8f6d749-5lmnr   1/1     Running   0          64m   10.233.74.69   node4   <none>           <none>
frontend-66d8f6d749-qnbds   1/1     Running   0          79s   10.233.71.4    node3   <none>           <none>
frontend-66d8f6d749-wv5w6   1/1     Running   0          79s   10.233.75.6    node2   <none>           <none>
root@debian11:~/13.3#
```

> **Scheduler** распределил реплики равномерно на все ноды, таким образом на каждой из трёх **worker** нод получился свой экземпляр **frontend** и **backend**

Описание **deploy** для **frontend**:

```console
root@debian11:~/13.3# kubectl describe deploy/frontend
Name:                   frontend
Namespace:              production
CreationTimestamp:      Mon, 02 Jan 2023 18:48:01 -0500
Labels:                 app=frontend
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=frontend
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=frontend
  Containers:
   frontend:
    Image:      artemshtepa/netology-app:frontend
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:
      BASE_URL:  http://backend-svc:9000
    Mounts:      <none>
  Volumes:       <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   frontend-66d8f6d749 (3/3 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  116s  deployment-controller  Scaled up replica set frontend-66d8f6d749 to 3 from 1
root@debian11:~/13.3#
```

Описание **deploy** для **backend**:

```console
root@debian11:~/13.3# kubectl describe deploy/backend
Name:                   backend
Namespace:              production
CreationTimestamp:      Mon, 02 Jan 2023 18:48:05 -0500
Labels:                 app=backend
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=backend
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=backend
  Containers:
   backend:
    Image:      artemshtepa/netology-app:backend
    Port:       9000/TCP
    Host Port:  0/TCP
    Environment:
      DATABASE_URL:  postgresql://postgres:postgres@db-svc:5432/news
    Mounts:          <none>
  Volumes:           <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   backend-7b4f6699f5 (3/3 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  2m9s  deployment-controller  Scaled up replica set backend-7b4f6699f5 to 3 from 1
root@debian11:~/13.3#
```

Изменение числа реплик **frontend** и **backend** до `1`:

```console
root@debian11:~/13.3# kubectl scale --replicas=1 deploy/backend
deployment.apps/backend scaled
root@debian11:~/13.3# kubectl scale --replicas=1 deploy/frontend
deployment.apps/frontend scaled
root@debian11:~/13.3# kubectl get pods
NAME                        READY   STATUS        RESTARTS   AGE
backend-7b4f6699f5-c4d8f    1/1     Running       0          66m
backend-7b4f6699f5-l5t8f    1/1     Terminating   0          3m10s
backend-7b4f6699f5-zkdjg    1/1     Terminating   0          3m10s
db-0                        1/1     Running       0          66m
frontend-66d8f6d749-5lmnr   1/1     Running       0          66m
root@debian11:~/13.3# kubectl get pods -o wide
NAME                        READY   STATUS    RESTARTS   AGE   IP             NODE    NOMINATED NODE   READINESS GATES
backend-7b4f6699f5-c4d8f    1/1     Running   0          67m   10.233.71.3    node3   <none>           <none>
db-0                        1/1     Running   0          67m   10.233.75.5    node2   <none>           <none>
frontend-66d8f6d749-5lmnr   1/1     Running   0          67m   10.233.74.69   node4   <none>           <none>
root@debian11:~/13.3#
```

> После изменения числа реплик до `1` **Scheduler** решил оставить "старые" **pods** как для **frontend**, так и **backend**.

<details>
<summary>Запрос лога <b>deployments</b></summary>

```console
root@debian11:~/13.3# kubectl describe deploy/frontend
Name:                   frontend
Namespace:              production
CreationTimestamp:      Mon, 02 Jan 2023 18:48:01 -0500
Labels:                 app=frontend
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=frontend
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=frontend
  Containers:
   frontend:
    Image:      artemshtepa/netology-app:frontend
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:
      BASE_URL:  http://backend-svc:9000
    Mounts:      <none>
  Volumes:       <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   frontend-66d8f6d749 (1/1 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  8m26s  deployment-controller  Scaled up replica set frontend-66d8f6d749 to 3 from 1
  Normal  ScalingReplicaSet  5m34s  deployment-controller  Scaled down replica set frontend-66d8f6d749 to 1 from 3
root@debian11:~/13.3# kubectl describe deploy/backend
Name:                   backend
Namespace:              production
CreationTimestamp:      Mon, 02 Jan 2023 18:48:05 -0500
Labels:                 app=backend
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=backend
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=backend
  Containers:
   backend:
    Image:      artemshtepa/netology-app:backend
    Port:       9000/TCP
    Host Port:  0/TCP
    Environment:
      DATABASE_URL:  postgresql://postgres:postgres@db-svc:5432/news
    Mounts:          <none>
  Volumes:           <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Progressing    True    NewReplicaSetAvailable
  Available      True    MinimumReplicasAvailable
OldReplicaSets:  <none>
NewReplicaSet:   backend-7b4f6699f5 (1/1 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  8m39s  deployment-controller  Scaled up replica set backend-7b4f6699f5 to 3 from 1
  Normal  ScalingReplicaSet  5m59s  deployment-controller  Scaled down replica set backend-7b4f6699f5 to 1 from 3
root@debian11:~/13.3#
```

</details>
