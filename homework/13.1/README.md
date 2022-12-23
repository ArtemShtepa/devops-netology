# Домашнее задание по лекции "13.1 контейнеры, поды, deployment, statefulset, services, endpoints"

> Настроив кластер, подготовьте приложение к запуску в нём.
> Приложение стандартное: бекенд, фронтенд, база данных.
> Его можно найти в папке [13-kubernetes-config](https://github.com/netology-code/devkub-homeworks/tree/main/13-kubernetes-config).

В **kubernetes** можно разворачивать только готовые образы,
поэтому на основе приложенных к заданию исходных кодов эти образы были собраны и залиты
на **DockerHub** под моей учётной запись.

Для успешной сборки изменён образ сборки **frontend** с `node:lts-buster` на более старый `node:lts-alpine3.14`.

> Для публикации образов на DockerHub нужно:
> 1. Авторизоваться в DockerHub Registry командой `docker login`
> 1. Прописать в `docker-compose.yml` названия образов (`image: ...`) из авторизованной учётной записи
> 1. Собрать образы из **Dockerfile** командой `docker build .`
> 1. Опубликовать образы командой `docker push`
>
> Для обоих образов использовался один репозиторий `artemshtepa/netology-app`, но разные тэги `frontend` и `backend`.

Исправленные исходные файлы образов продублированы в каталоге [src](./src).
Также в этом каталоге находятся вспомогательные скрипты и файлы управления инфраструктурой.
Все готовые файлы манифестов находятся в каталоге [manifests](./manifests).

## Задание 1: подготовить тестовый конфиг для запуска приложения

> Для начала следует подготовить запуск приложения в stage окружении с простыми настройками.
> Требования:
> * под содержит в себе 2 контейнера — фронтенд, бекенд;
> * регулируется с помощью deployment фронтенд и бекенд;
> * база данных — через statefulset.

Параметры образа [PostgreSQL](https://hub.docker.com/_/postgres)

Так как в **Docker** манифесте указаны порты до `30000`, то тип **service** может быть только **ClusterIP** - устанавливается по умолчанию

Сущности будут разворачиваться в отдельном **namespace** (окружение **stage**), создать который можно командой `kubectl create namespace stage`

```console
root@debian11:~/13.1# kubectl create namespace stage
namespace/stage created
root@debian11:~/13.1#
```

Для управления данными в окружении **stage** нужно либо в командах указывать **namespace** ключами `-n stage`, либо задать **namespace** по умолчанию, командой `kubectl config set-context --current --namespace=stage`

### Манифест создания **PersistentVolume** [файл](./manifests/pv.yml)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: db-pv
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 3Gi
  hostPath:
    path: /data/pv
  persistentVolumeReclaimPolicy: Retain
```

### Манифест создания основного **pod** [файл](./manifests/stage-app.yml)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: testapp
  name: testapp
  namespace: stage
spec:
  replicas: 1
  selector:
    matchLabels:
      app: testapp
  template:
    metadata:
      labels:
        app: testapp
    spec:
      containers:
        - name: frontend
          image: artemshtepa/netology-app:frontend
          imagePullPolicy: IfNotPresent
          ports:
            - name: frontend-port
              containerPort: 80
              protocol: TCP
        - name: backend
          image: artemshtepa/netology-app:backend
          imagePullPolicy: IfNotPresent
          ports:
            - name: backend-port
              containerPort: 9000
              protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: testapp-svc
  namespace: stage
spec:
  selector:
    app: testapp
  ports:
    - name: frontend-svc
      port: 8000
      targetPort: 80
      protocol: TCP
    - name: backend-svc
      port: 9000
      targetPort: 9000
      protocol: TCP
```

Манифест создания **StatefulSet** (включая **service** и запрос пространства **PersistentVolumeClaim** [файл](./manifests/stage-db.yml)

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  labels:
    app: db
  name: db
  namespace: stage
spec:
  selector:
    matchLabels:
      app: db
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
        - name: db
          image: postgres:13-alpine
          imagePullPolicy: "IfNotPresent"
          env:
            - name: POSTGRES_USER
              value: postgres
            - name: POSTGRES_PASSWORD
              value: postgres
            - name: POSTGRES_DB
              value: news
          volumeMounts:
            - name: db-volume
              mountPath: "/var/lib/postgresql/data"
      volumes:
        - name: db-volume
          persistentVolumeClaim:
            claimName: db-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: db-svc
  namespace: stage
spec:
  ports:
    - name: db
      port: 5432
      targetPort: 5432
      protocol: TCP
  selector:
    app: db
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: db-pvc
  namespace: stage
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
```

<details>
<summary>Применение настроек :</summary>

```console
root@debian11:~/13.1# kubectl apply -f manifests/pv.yml
persistentvolume/db-pv created
root@debian11:~/13.1# kubectl apply -f manifests/stage-app.yml
deployment.apps/testapp created
service/testapp-svc unchanged
root@debian11:~/13.1# kubectl apply -f manifests/stage-db.yml
statefulset.apps/db created
service/db-svc unchanged
persistentvolumeclaim/db-pvc created
root@debian11:~/13.1#
```
</details>

### Запрос созданных ресурсов

**Pods**:

```console
root@debian11:~/13.1# kubectl get po -o wide
NAME                       READY   STATUS    RESTARTS   AGE     IP            NODE    NOMINATED NODE   READINESS GATES
db-0                       1/1     Running   0          8m19s   10.233.75.4   node2   <none>           <none>
testapp-5565f7db9b-nqgfb   2/2     Running   0          8m28s   10.233.75.3   node2   <none>           <none>
root@debian11:~/13.1#
```

**Statefulset**:

```console
root@debian11:~/13.1# kubectl get sts -o wide
NAME   READY   AGE     CONTAINERS   IMAGES
db     1/1     8m25s   db           postgres:13-alpine
root@debian11:~/13.1#
```

**PersistentVolumeClaim**:

```console
root@debian11:~/13.1# kubectl get pvc -o wide
NAME     STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE     VOLUMEMODE
db-pvc   Bound    db-pv    3Gi        RWO                           8m32s   Filesystem
root@debian11:~/13.1#
```

**PersistentVolume**:

```console
root@debian11:~/13.1# kubectl get pv -o wide
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM          STORAGECLASS   REASON   AGE     VOLUMEMODE
db-pv   3Gi        RWO            Retain           Bound    stage/db-pvc                           8m57s   Filesystem
root@debian11:~/13.1#
```

**Services**:

```console
root@debian11:~/13.1# kubectl get svc -o wide
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE     SELECTOR
db-svc        ClusterIP   10.233.13.180   <none>        5432/TCP            8m49s   app=db
testapp-svc   ClusterIP   10.233.28.228   <none>        8000/TCP,9000/TCP   8m57s   app=testapp
root@debian11:~/13.1#
```

<details>
<summary>Удаление ресурсов :</summary>

```console
root@debian11:~/13.1# kubectl delete deploy testapp
deployment.apps "testapp" deleted
root@debian11:~/13.1# kubectl delete sts db
statefulset.apps "db" deleted
root@debian11:~/13.1# kubectl delete pvc db-pvc
persistentvolumeclaim "db-pvc" deleted
root@debian11:~/13.1# kubectl delete pv db-pv
persistentvolume "db-pv" deleted
root@debian11:~/13.1# kubectl delete svc db-svc
service "db-svc" deleted
root@debian11:~/13.1# kubectl delete svc testapp-svc
service "testapp-svc" deleted
root@debian11:~/13.1#
```
</details>

---

## Задание 2: подготовить конфиг для production окружения

> Следующим шагом будет запуск приложения в production окружении.
> Требования сложнее:
> * каждый компонент (база, бекенд, фронтенд) запускаются в своем поде, регулируются отдельными deployment’ами;
> * для связи используются service (у каждого компонента свой);
> * в окружении фронта прописан адрес сервиса бекенда;
> * в окружении бекенда прописан адрес сервиса базы данных.

Названия переменных для СУБД можно посмотреть в файлах `.env` (`.env.example`) как для **frontend** так и для **backend**.

### Манифест создания **frontend** [файл](./manifests/prod-frontend.yml)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: frontend
  name: frontend
  namespace: production
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: frontend
          image: artemshtepa/netology-app:frontend
          imagePullPolicy: IfNotPresent
          env:
            - name: BASE_URL
              value: http://backend-svc:9000
          ports:
            - name: frontend-port
              containerPort: 80
              protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-svc
  namespace: production
spec:
  selector:
    app: frontend
  ports:
    - name: frontend-port
      port: 8000
      targetPort: 80
      protocol: TCP
```

### Манифест создания **backend** [файл](./manifests/prod-backend.yml)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: backend
  name: backend
  namespace: production
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
        - name: backend
          image: artemshtepa/netology-app:backend
          imagePullPolicy: IfNotPresent
          env:
            - name: DATABASE_URL
              value: "postgresql://postgres:postgres@db-svc:5432/news"
          ports:
            - name: backend-port
              containerPort: 9000
              protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: backend-svc
  namespace: production
spec:
  selector:
    app: backend
  ports:
    - name: backend-port
      port: 9000
      targetPort: 9000
      protocol: TCP
```

### Манифест создания базы данных [файл](./manifests/prod-db.yml)

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  labels:
    app: db
  name: db
  namespace: production
spec:
  selector:
    matchLabels:
      app: db
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
        - name: db
          image: postgres:13-alpine
          imagePullPolicy: "IfNotPresent"
          env:
            - name: POSTGRES_USER
              value: postgres
            - name: POSTGRES_PASSWORD
              value: postgres
            - name: POSTGRES_DB
              value: news
          volumeMounts:
            - name: db-volume
              mountPath: "/var/lib/postgresql/data"
      volumes:
        - name: db-volume
          persistentVolumeClaim:
            claimName: db-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: db-svc
  namespace: production
spec:
  ports:
    - name: db
      port: 5432
      targetPort: 5432
      protocol: TCP
  selector:
    app: db
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: db-pvc
  namespace: production
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
```

<details>
<summary>Применение настроек :</summary>

```console
root@debian11:~/13.1# kubectl create namespace production
namespace/production created
root@debian11:~/13.1# kubectl config set-context --current --namespace=production
Context "kubernetes-admin@cluster.local" modified.
root@debian11:~/13.1# kubectl apply -f manifests/pv.yml
persistentvolume/db-pv created
root@debian11:~/13.1# kubectl apply -f manifests/prod-frontend.yml
deployment.apps/frontend created
service/frontend-svc created
root@debian11:~/13.1# kubectl apply -f manifests/prod-backend.yml
deployment.apps/backend created
service/backend-svc created
root@debian11:~/13.1# kubectl apply -f manifests/prod-db.yml
statefulset.apps/db created
service/db-svc created
persistentvolumeclaim/db-pvc created
root@debian11:~/13.1#
```
</details>

### Запрос созданных ресурсов

```console
root@debian11:~/13.1# kubectl get all
NAME                            READY   STATUS    RESTARTS   AGE
pod/backend-7b4f6699f5-4nx59    1/1     Running   0          44s
pod/db-0                        1/1     Running   0          32s
pod/frontend-66d8f6d749-8qppc   1/1     Running   0          38s

NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/backend-svc    ClusterIP   10.233.14.252   <none>        9000/TCP   45s
service/db-svc         ClusterIP   10.233.36.243   <none>        5432/TCP   33s
service/frontend-svc   ClusterIP   10.233.43.42    <none>        8000/TCP   38s

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/backend    1/1     1            1           47s
deployment.apps/frontend   1/1     1            1           39s

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/backend-7b4f6699f5    1         1         1       46s
replicaset.apps/frontend-66d8f6d749   1         1         1       39s

NAME                  READY   AGE
statefulset.apps/db   1/1     33s
root@debian11:~/13.1#
```

---

## Задание 3 (*): добавить endpoint на внешний ресурс api

> Приложению потребовалось внешнее api, и для его использования лучше добавить endpoint в кластер, направленный на это api. Требования:
> * добавлен endpoint до внешнего api (например, геокодер).

Для реализации вызова к внешниму API:
 - Добавлен **service** `ext`
 - К сервису привязан **ingress** с точкой входа `ext`
 - К сервису подключен **endpoint**, ведущий на внешний IP адрес

### Манифест создания **Endpoint** [файл](./manifests/prod-ep.yml)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: ext
  namespace: production
spec:
  ports:
  - name: app
    port: 8080
    protocol: TCP
    targetPort: 8080
  clusterIP: None
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ext
  namespace: production
spec:
  rules:
  - http:
      paths:
      - path: /ext
        pathType: Exact
        backend:
          service:
            name: ext
            port:
              number: 8080
---
apiVersion: v1
kind: Endpoints
metadata:
  name: ext
  namespace: production
subsets:
- addresses:
  - ip: 213.180.193.58
  ports:
  - name: external-api
    port: 80
    protocol: TCP
```

### Применение и запрос конфигурации **Endpoint**:

```console
root@debian11:~/13.1# kubectl apply -f manifests/prod-ep.yml
service/ext created
ingress.networking.k8s.io/ext created
endpoints/ext created
root@debian11:~/13.1# kubectl get svc,ing,ep
NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/backend-svc    ClusterIP   10.233.14.252   <none>        9000/TCP   62m
service/db-svc         ClusterIP   10.233.36.243   <none>        5432/TCP   62m
service/ext            ClusterIP   None            <none>        8080/TCP   2m43s
service/frontend-svc   ClusterIP   10.233.43.42    <none>        8000/TCP   62m

NAME                            CLASS    HOSTS   ADDRESS   PORTS   AGE
ingress.networking.k8s.io/ext   <none>   *                 80      2m43s

NAME                     ENDPOINTS           AGE
endpoints/backend-svc    10.233.75.9:9000    62m
endpoints/db-svc         10.233.75.11:5432   62m
endpoints/ext            213.180.193.58:80   2m42s
endpoints/frontend-svc   10.233.75.10:80     62m
root@debian11:~/13.1#
```

### Проверка отправкой запроса на внешний **endpoint**:

```console
root@debian11:~/13.1# kubectl exec frontend-66d8f6d749-8qppc -- curl -v -s ext
*   Trying 213.180.193.58:80...
* Connected to ext (213.180.193.58) port 80 (#0)
> GET / HTTP/1.1
> Host: ext
> User-Agent: curl/7.74.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 404 Not found
< Content-Length: 0
< Set-Cookie: _yasc=gr7oWxhWsUvseU1HQk7KptXIxZhdJNw0QY8vf4P86/AfkMW3CPbV1aQNkeo=; domain=.ext; path=/; expires=Sun, 26-Dec-2032 14:20:23 GMT; secure
<
* Connection #0 to host ext left intact
root@debian11:~/13.1#
```
