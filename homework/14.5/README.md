# Домашнее задание по лекции "14.5 SecurityContext, NetworkPolicies"

## Обязательная задача 1: Рассмотрите пример example-security-context.yml

Приложенный к заданию манифест:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  containers:
  - name: sec-ctx-demo
    image: fedora:latest
    command: [ "id" ]
    # command: [ "sh", "-c", "sleep 1h" ]
    securityContext:
      runAsUser: 1000
      runAsGroup: 3000
```

В указанном манифесте создаётся:
  - **pod** с именем `security-context-demo`
  - В **pod** разворачивается один контейнер с именем `sec-ctx-demo` на основе образа `fedora:latest`
  - В контейнере выполняется команда `id`, выводящая уникальный идентификатор пользователя (`UUID`) от которого запускается контейнер, идентификатор его группы (`GID`) и других группы (`GROUPS`), в которые входит пользователь
  - Для контейнера задан **securityContext**, в котором указано, что контейнер нужно запускать от пользователя с **UUID=1000**: `runAsUser: 1000`, и группы **GID=3000** (`runAsGroup: 3000`)

После применения данного манифеста **pod** создастся, запустится, отработает команда `id` и **pod** остановится, сохранив в своих логах вывод команды.

Проверка:

```console
root@debian11:~/14.5# kubectl apply -f example-security-context.yml
pod/security-context-demo created
root@debian11:~/14.5# kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
root@debian11:~/14.5#
```

---

## Дополнительная задача 2 (*): Рассмотрите пример example-network-policy.yml

Приложенный к заданию манифест:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - ipBlock:
        cidr: 172.17.0.0/16
        except:
        - 172.17.1.0/24
    - namespaceSelector:
        matchLabels:
          project: myproject
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 6379
  egress:
  - to:
    - ipBlock:
        cidr: 10.0.0.0/24
    ports:
    - protocol: TCP
      port: 5978
```

Указанный манифест применяется для всех **pods** из **namespace** `default` следующие правила:
  - Применяются политики `Ingress` и `Egress`, то есть блокируются все входящие и исходящие соединения, кроме разрешенных (перечислены ниже)
  - Разрешаются входящие соединения на порт `6379` по протоколу **TCP** с диапазона **IP** адресов `172.17.0.0/16`, кроме `172.17.1.0/24`, или для **pod** с меткой `role: frontend` в **namespace default** или всех **pod namespace** с меткой `project: myproject`
  - Разрешаются исходящие соединения на порт `5978` для диспазона **IP** адресов `10.0.0.0/24`

> Создайте два модуля. Для первого модуля разрешите доступ к внешнему миру
> и ко второму ~контейнеру~ модулю. Для второго модуля разрешите связь только с
> первым ~контейнером~ модулем. Проверьте корректность настроек.
>
> В данном случае под выражением "модуль" понимается **pod Kubernetes**

Разрешение доступа первого **pod** к внешнему миру в купе с разрешением доступа ко
второму **pod** может быть эквивалентно запрету всех входящих соединений, кроме входящих
соединений от второго **pod**, то есть для первого **pod** нужно применить только политику
`Ingress`, где явно разрешить входящие соединения со второго **pod**.

Для второго **pod** разрешить только связь с первым **pod** означает блокировку всех соединений
(применение политик `Ingress` и `Egress`), кроме входящих и исходящих с первого **pod**
(детализация `Ingress` и `Egress` с указанием первого **pod**). Однако, в этом случае потеряется
связъ с **DNS** службой **Kubernetes** и сервисы **ClusterIP** не будут доступны по именам.

Манифест создания первого **pod** на основе [wbitt/network-multitool](https://hub.docker.com/r/wbitt/network-multitool)

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-html-1
data:
  index.html: |
    Hello from FIRST module
---
apiVersion: v1
kind: Pod
metadata:
  name: pod-1
  labels:
    app: pod-1
spec:
  containers:
  - name: multitool-1
    image: wbitt/network-multitool
    ports:
    - containerPort: 80
    volumeMounts:
      - name: html
        mountPath: /usr/share/nginx/html
  volumes:
  - name: html
    configMap:
      name: nginx-html-1
---
apiVersion: v1
kind: Service
metadata:
  name: pod-svc-1
spec:
  ports:
    - name: http-port
      port: 80
  selector:
    app: pod-1
...
```

Манифест включает **ConfigMap** с настройкой стартовой страницы **nginx**,
которая будет выводить фразу `Hello from FIRST module`, а также сервис для подключения к **nginx**.

Манифест второго **pod** аналогичен первому, за исключением передаваемой **nginx** фразы: `Hello from SECOND module`

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-html-2
data:
  index.html: |
    Hello from SECOND module
---
apiVersion: v1
kind: Pod
metadata:
  name: pod-2
  labels:
    app: pod-2
spec:
  containers:
  - name: multitool-2
    image: wbitt/network-multitool
    ports:
    - containerPort: 80
    volumeMounts:
      - name: html
        mountPath: /usr/share/nginx/html
  volumes:
  - name: html
    configMap:
      name: nginx-html-2
---
apiVersion: v1
kind: Service
metadata:
  name: pod-svc-2
spec:
  ports:
    - name: http-port
      port: 80
  selector:
    app: pod-2
...
```
Манифест политики безопасности, описанной в условии задачи:

```yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: network-policy-1
spec:
  podSelector:
    matchLabels:
      app: pod-1
  policyTypes:
    - Ingress
  ingress:
    - from:
      - podSelector:
          matchLabels:
            app: pod-2
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: network-policy-2
spec:
  podSelector:
    matchLabels:
      app: pod-2
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
      - podSelector:
          matchLabels:
            app: pod-1
  egress:
    - to:
      - podSelector:
          matchLabels:
            app: pod-1
...
```

> Исходный код манифестов также представлен [файлами](./src/)

### Проверка

В решении будет использоваться отдельный **namespace** `145`

```console
root@debian11:~/14.5# kubectl create ns 145
namespace/145 created
root@debian11:~/14.5#
```

Так как в манифестах конкретный **namespace** не указан, я изменил настройки текущего контекста:

```console
root@debian11:~/14.5# kubectl config set-context --current --namespace 145
Context "kubernetes-admin@cluster.local" modified.
root@debian11:~/14.5#
```

Применение манифестов

```console
root@debian11:~/14.5# kubectl apply -f '*.yml'
networkpolicy.networking.k8s.io/network-policy-1 created
networkpolicy.networking.k8s.io/network-policy-2 created
configmap/nginx-html-1 created
pod/pod-1 created
service/pod-svc-1 created
configmap/nginx-html-2 created
pod/pod-2 created
service/pod-svc-2 created
root@debian11:~/14.5#
```

Состояние кластера в **namespace** `145`

```console
root@debian11:~/14.5# kubectl get all -o wide
NAME        READY   STATUS    RESTARTS   AGE   IP             NODE    NOMINATED NODE   READINESS GATES
pod/pod-1   1/1     Running   0          36s   10.233.75.24   node2   <none>           <none>
pod/pod-2   1/1     Running   0          36s   10.233.71.19   node3   <none>           <none>

NAME                TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE   SELECTOR
service/pod-svc-1   ClusterIP   10.233.17.39    <none>        80/TCP    36s   app=pod-1
service/pod-svc-2   ClusterIP   10.233.24.111   <none>        80/TCP    36s   app=pod-2
root@debian11:~/14.5#
```

Проверка доступности "внешнего мира" и второго **pod** из первого, а также недоступность первого извне:

```console
root@debian11:~/14.5# kubectl exec pod-1 -- curl -v -s http://ya.ru
*   Trying 5.255.255.242:80...
* Connected to ya.ru (5.255.255.242) port 80 (#0)
> GET / HTTP/1.1
> Host: ya.ru
> User-Agent: curl/7.80.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 301 Moved permanently
< Accept-CH: Sec-CH-UA-Platform-Version, Sec-CH-UA-Mobile, Sec-CH-UA-Model, Sec-CH-UA, Sec-CH-UA-Full-Version-List, Sec-CH-UA-WoW64, Sec-CH-UA-Arch, Sec-CH-UA-Bitness, Sec-CH-UA-Platform, Sec-CH-UA-Full-Version, Viewport-Width, DPR, Device-Memory, RTT, Downlink, ECT
< Cache-Control: max-age=1209600,private
< Date: Sun, 19 Feb 2023 10:53:12 GMT
< Location: https://ya.ru/
< NEL: {"report_to": "network-errors", "max_age": 100, "success_fraction": 0.001, "failure_fraction": 0.1}
< P3P: policyref="/w3c/p3p.xml", CP="NON DSP ADM DEV PSD IVDo OUR IND STP PHY PRE NAV UNI"
< Portal: Home
< Report-To: { "group": "network-errors", "max_age": 100, "endpoints": [{"url": "https://dr.yandex.net/nel", "priority": 1}, {"url": "https://dr2.yandex.net/nel", "priority": 2}]}
< Transfer-Encoding: chunked
< X-Content-Type-Options: nosniff
< X-Yandex-Req-Id: 1676803992153402-7013766121447765738-sas3-0778-625-sas-l7-balancer-8080-BAL-6030
< set-cookie: is_gdpr=0; Path=/; Domain=.ya.ru; Expires=Tue, 18 Feb 2025 10:53:12 GMT
< set-cookie: is_gdpr_b=CKWxOxDFpwEoAg==; Path=/; Domain=.ya.ru; Expires=Tue, 18 Feb 2025 10:53:12 GMT
< set-cookie: _yasc=LPOug8fBf8iaq8TZKNI8DJZ2g1t8aEL8XMMBK8RFUC+uR5IloZuo3Vtx3vlSNg==; domain=.ya.ru; path=/; expires=Wed, 16-Feb-2033 10:53:12 GMT; secure
<
{ [5 bytes data]
* Connection #0 to host ya.ru left intact
root@debian11:~/14.5# kubectl exec pod-1 -- curl -s http://pod-svc-2
Hello from SECOND module
root@debian11:~/14.5# kubectl exec pod-1 -- curl -s http://127.0.0.1
Hello from FIRST module
root@debian11:~/14.5# kubectl exec pod-1 -- ping http://pod-svc-1
ping: http://pod-svc-1: Name does not resolve
command terminated with exit code 2
root@debian11:~/14.5# kubectl exec pod-1 -- ping 10.233.17.39
PING 10.233.17.39 (10.233.17.39) 56(84) bytes of data.
From 10.233.17.39 icmp_seq=1 Destination Port Unreachable
From 10.233.17.39 icmp_seq=2 Destination Port Unreachable
From 10.233.17.39 icmp_seq=3 Destination Port Unreachable
From 10.233.17.39 icmp_seq=4 Destination Port Unreachable
^C
root@debian11:~/14.5#
```

Проверка подключения к первому **pod** из второго и недоступность "внешнего мира":

```console
root@debian11:~/14.5# kubectl exec pod-2 -- curl -s http://127.0.0.1
Hello from SECOND module
root@debian11:~/14.5# kubectl exec pod-2 -- curl -s http://10.233.75.24
Hello from FIRST module
root@debian11:~/14.5# kubectl exec pod-2 -- curl -s http://10.233.17.39
Hello from FIRST module
root@debian11:~/14.5# kubectl exec pod-2 -- ping http://pod-svc-2
ping: http://pod-svc-2: Try again
command terminated with exit code 2
root@debian11:~/14.5# kubectl exec pod-2 -- curl -v -s http://ya.ru
* Could not resolve host: ya.ru
* Closing connection 0
command terminated with exit code 6
root@debian11:~/14.5# kubectl exec pod-2 -- curl -v -s --max-time 5 http://5.255.255.242:80
*   Trying 5.255.255.242:80...
* Connection timed out after 5001 milliseconds
* Closing connection 0
command terminated with exit code 28
root@debian11:~/14.5#
```
