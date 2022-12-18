# Домашнее задание по лекции "12.5 Сетевые решения CNI"

> После работы с Flannel появилась необходимость обеспечить безопасность для приложения.
> Для этого лучше всего подойдет Calico.

Подготовленная инфраструктура:

```console
root@debian11:~/12.5# yc compute instance list
+----------------------+---------------+---------------+---------+----------------+-------------+
|          ID          |     NAME      |    ZONE ID    | STATUS  |  EXTERNAL IP   | INTERNAL IP |
+----------------------+---------------+---------------+---------+----------------+-------------+
| fhm4ggkmhs0ia5i5l2d7 | kube-master-1 | ru-central1-a | RUNNING | 158.160.48.227 | 10.2.0.8    |
| fhmodflusb5vodv2s424 | kube-worker-1 | ru-central1-a | RUNNING | 158.160.57.65  | 10.2.0.17   |
+----------------------+---------------+---------------+---------+----------------+-------------+
```

## Задание 1: установить в кластер CNI плагин Calico

> Для проверки других сетевых решений стоит поставить отличный от Flannel плагин — например, Calico. Требования: 
> * установка производится через ansible/kubespray;
> * после применения следует настроить политику доступа к hello-world извне. Инструкции [kubernetes.io](https://kubernetes.io/docs/concepts/services-networking/network-policies/), [Calico](https://docs.projectcalico.org/about/about-network-policy)

Конфигурирование и установка кластера аналогична решению задания [12.4](./../12.4/), за исключением числа **worker** нод, сниженных до 1.

Выбор **CNI**[^1] осуществляется заданием параметра `kube_network_plugin`, расположенного в файле `group_vars/k8s_cluster/k8s-cluster.yml` относительно используемого каталога **inventory**.
`calico` установлен по умолчанию.

После настройки кластера, **CNI plugin calico** создал сеть и маршруты по умолчанию (запрос маршрутов с "машинки" **control plane**):

```console
root@debian11:~/12.5# ssh debian@158.160.48.227
Linux node1 5.10.0-19-amd64 #1 SMP Debian 5.10.149-2 (2022-10-21) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Mon Dec 19 16:06:32 2022 from 85.143.205.34
debian@node1:~$ sudo route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.2.0.1        0.0.0.0         UG    0      0        0 eth0
10.2.0.0        0.0.0.0         255.255.0.0     U     0      0        0 eth0
10.233.75.0     10.233.75.0     255.255.255.192 UG    0      0        0 vxlan.calico
10.233.102.128  0.0.0.0         255.255.255.192 U     0      0        0 *
10.233.102.129  0.0.0.0         255.255.255.255 UH    0      0        0 cali86177151235
10.233.102.130  0.0.0.0         255.255.255.255 UH    0      0        0 cali09a92e8c768
debian@node1:~$
```

В качестве **hello-world** взят образ [fhsinchy Hello Kube](https://github.com/fhsinchy/kubernetes-handbook-projects/tree/master), позволяющий отвечать на HTTP запросы выводом небольшого HTML кода.
Разворачивание выполняется через **deployment** командой: `kubectl create deployment hello --image=fhsinchy/hello-kube --port=80`

Для тестирования также используется образ [Network-MultiTool](https://github.com/Praqma/Network-MultiTool), позволяющий отправлять HTTP запросы.
Разворачивание выполняется через файл манифеста [multitool](./src/multitool.yml)

После подготовки кластера на нём были развёрнулы образы **hello** и **multitool**.

В условиях задачи не указано какую именно политику нужно написать, поэтому она будет следующая:
Для контейнера **hello** запрещаются все исходящие соединения, в входящие ограничены только портом 80.

Описание политики представлено в виде файла манифеста [hello-policy](./src/hello-policy.yml) со следующим содержимым:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: hello-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: hello
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
      - podSelector: {}
      ports:
        - protocol: TCP
          port: 80
```

Блок `policyTypes` указывает какие правила (исходящие, входящие) описаны в данном манифсте.
По умолчанию, при определении типа в этом блоке, все соотвествующие соединения блокируются.
А разрешения указываются дополнительно в одноимённых блоках.

Например, в моём примере строки:
```yaml
  podSelector:
    matchLabels:
      app: hello
```
говорят применении к **pod** с меткой (**label**) `hello` политики безопасности (`kind: NetworkPolicy`) со следующими правилами:
```yaml
  policyTypes:
    - Ingress
    - Egress
```
что указывает на блокировку всех входящих и исходящих соединений, кроме разрешённых:
```yaml
  ingress:
    - from:
      - podSelector: {}
      ports:
        - protocol: TCP
          port: 80
```
входящих (`ingress`) со всех **pod** (`podSelector: {}`) на порт **80** (`port: 80`) по протоколу **TCP** (`protocol: TCP`)

Применение политики безопасности выполняется командой: `kubectl apply -f hello-policy.yml`

Лог подготовки приложений и запрос описания политики безопасности:
```console
root@debian11:~/12.5# kubectl create deployment hello --image=fhsinchy/hello-kube --port=80
deployment.apps/hello created
root@debian11:~/12.5# kubectl apply -f multitool.yml
deployment.apps/multitool created
root@debian11:~/12.5# kubectl apply -f hello-policy.yml
networkpolicy.networking.k8s.io/hello-policy created
root@debian11:~/12.5# kubectl get networkpolicy
NAME           POD-SELECTOR   AGE
hello-policy   app=hello      23s
root@debian11:~/12.5# kubectl describe networkpolicy hello-policy
Name:         hello-policy
Namespace:    default
Created on:   2022-12-19 20:10:22 +0300 MSK
Labels:       <none>
Annotations:  <none>
Spec:
  PodSelector:     app=hello
  Allowing ingress traffic:
    To Port: 80/TCP
    From:
      PodSelector: <none>
  Allowing egress traffic:
    <none> (Selected pods are isolated for egress connectivity)
  Policy Types: Ingress, Egress
root@debian11:~/12.5#
```

Проверка политики осуществляется отправкой **curl** запроса из **pod** **multitool** на IP адрес **pod** **hello**.

### Проверка функционирования при настройке **hello** на **80** порт

Запрос описания **pod** **hello**, чтобы узнать его IP адрес и порт на котором он функционирует:

```console
root@debian11:~/12.5# kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
hello-549f7bd579-765dd       1/1     Running   0          84s
multitool-68cf8b75ff-z5mjq   1/1     Running   0          76s
root@debian11:~/12.5# kubectl describe pods/hello-549f7bd579-765dd
Name:             hello-549f7bd579-765dd
Namespace:        default
Priority:         0
Service Account:  default
Node:             node2/10.2.0.17
Start Time:       Mon, 19 Dec 2022 20:10:03 +0300
Labels:           app=hello
                  pod-template-hash=549f7bd579
Annotations:      cni.projectcalico.org/containerID: a636dd29425a4698ad9485e9f470c4a633d556e0e67af6e799b47ea7c1544934
                  cni.projectcalico.org/podIP: 10.233.75.8/32
                  cni.projectcalico.org/podIPs: 10.233.75.8/32
Status:           Running
IP:               10.233.75.8
IPs:
  IP:           10.233.75.8
Controlled By:  ReplicaSet/hello-549f7bd579
Containers:
  hello-kube:
    Container ID:   containerd://faf017b8ee2a20863967f201d82e87d008268420ec584d89f61877843f48f967
    Image:          fhsinchy/hello-kube
    Image ID:       docker.io/fhsinchy/hello-kube@sha256:5c90791b6ad8c48b2e5a673e447fc6c12118a179bd9866904c6f02eb5274053d
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 19 Dec 2022 20:10:08 +0300
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-m7q4z (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-m7q4z:
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
  Normal  Scheduled  95s   default-scheduler  Successfully assigned default/hello-549f7bd579-765dd to node2
  Normal  Pulling    92s   kubelet            Pulling image "fhsinchy/hello-kube"
  Normal  Pulled     91s   kubelet            Successfully pulled image "fhsinchy/hello-kube" in 1.182537623s
  Normal  Created    91s   kubelet            Created container hello-kube
  Normal  Started    90s   kubelet            Started container hello-kube
```

Запрос ответа **hello** по внутреннему адресу `10.233.75.8:80`

```console
root@debian11:~/12.5# kubectl exec multitool-68cf8b75ff-z5mjq -- curl -s --max-time 1 10.233.75.8:80
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <link rel="icon" href="/favicon.ico" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>The Kubernetes Handbook</title>
<script type="module" src="/_assets/index.7e1a889d.js"></script>
<link rel="stylesheet" href="/_assets/style.0637ccc5.css">
</head>
<body>
  <div id="app"></div>

</body>
</html>
root@debian11:~/12.5# kubectl edit deployment hello
```

### Проверка функционирования при настройке **hello** на **82** порт

Для изменения порта я использовал команду редактирования **deployment**:
```console
root@debian11:~/12.5# kubectl edit deployment hello
deployment.apps/hello edited
```

После изменений **pod** будет перезапущен (сменится имя и скорее всего поменяется IP адрес), поэтому запрашиваем описание заново:

```console
root@debian11:~/12.5# kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
hello-76b9cc7c85-58rmk       1/1     Running   0          24s
multitool-68cf8b75ff-z5mjq   1/1     Running   0          3m48s
root@debian11:~/12.5# kubectl describe pods/hello-76b9cc7c85-58rmk
Name:             hello-76b9cc7c85-58rmk
Namespace:        default
Priority:         0
Service Account:  default
Node:             node2/10.2.0.17
Start Time:       Mon, 19 Dec 2022 20:13:35 +0300
Labels:           app=hello
                  pod-template-hash=76b9cc7c85
Annotations:      cni.projectcalico.org/containerID: 412cf782ca436b4d9e216e38b7d91bf9ecef5683760d1a4710be76e20f57975c
                  cni.projectcalico.org/podIP: 10.233.75.10/32
                  cni.projectcalico.org/podIPs: 10.233.75.10/32
Status:           Running
IP:               10.233.75.10
IPs:
  IP:           10.233.75.10
Controlled By:  ReplicaSet/hello-76b9cc7c85
Containers:
  hello-kube:
    Container ID:   containerd://7dde5bc0ccda671bd04f834a3404f074a2b592fdd0c5c16145e762b4ffd2a991
    Image:          fhsinchy/hello-kube
    Image ID:       docker.io/fhsinchy/hello-kube@sha256:5c90791b6ad8c48b2e5a673e447fc6c12118a179bd9866904c6f02eb5274053d
    Port:           82/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 19 Dec 2022 20:13:38 +0300
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-hjl5x (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-hjl5x:
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
  Normal  Scheduled  47s   default-scheduler  Successfully assigned default/hello-76b9cc7c85-58rmk to node2
  Normal  Pulling    46s   kubelet            Pulling image "fhsinchy/hello-kube"
  Normal  Pulled     45s   kubelet            Successfully pulled image "fhsinchy/hello-kube" in 1.113167097s
  Normal  Created    44s   kubelet            Created container hello-kube
  Normal  Started    44s   kubelet            Started container hello-kube
```
> Из вывода видно, что имя, IP адрес и порт были изменены

Запрос ответа **hello** по новому адресу `10.233.75.10:82`:
```console
root@debian11:~/12.5# kubectl exec multitool-68cf8b75ff-z5mjq -- curl -s --max-time 1 10.233.75.10:82
command terminated with exit code 28
root@debian11:~/12.5#
```

> Ожидаемо подключиться не удалось, так как доступ разрешен только для 80 порта

---

## Задание 2: изучить, что запущено по умолчанию

> Самый простой способ — проверить командой calicoctl get <type>. Для проверки стоит получить список нод, ipPool и profile.
> Требования: 
> * установить утилиту calicoctl;
> * получить 3 вышеописанных типа в консоли.

Установка **calicoctl** выполняется по [документации](https://projectcalico.docs.tigera.io/maintenance/clis/calicoctl/install)

Получение списка нод:

```console
root@debian11:~/12.5# calicoctl get nodes
NAME
node1
node2

root@debian11:~/12.5#
```

Получение пулов IP адресов:

```console
root@debian11:~/12.5# calicoctl get ipPool
NAME           CIDR             SELECTOR
default-pool   10.233.64.0/18   all()

root@debian11:~/12.5#
```

Получение списка профилей:

```console
root@debian11:~/12.5# calicoctl get profile
NAME
projectcalico-default-allow
kns.default
kns.kube-node-lease
kns.kube-public
kns.kube-system
ksa.default.default
ksa.kube-node-lease.default
ksa.kube-public.default
ksa.kube-system.attachdetach-controller
ksa.kube-system.bootstrap-signer
ksa.kube-system.calico-kube-controllers
ksa.kube-system.calico-node
ksa.kube-system.certificate-controller
ksa.kube-system.clusterrole-aggregation-controller
ksa.kube-system.coredns
ksa.kube-system.cronjob-controller
ksa.kube-system.daemon-set-controller
ksa.kube-system.default
ksa.kube-system.deployment-controller
ksa.kube-system.disruption-controller
ksa.kube-system.dns-autoscaler
ksa.kube-system.endpoint-controller
ksa.kube-system.endpointslice-controller
ksa.kube-system.endpointslicemirroring-controller
ksa.kube-system.ephemeral-volume-controller
ksa.kube-system.expand-controller
ksa.kube-system.generic-garbage-collector
ksa.kube-system.horizontal-pod-autoscaler
ksa.kube-system.job-controller
ksa.kube-system.kube-proxy
ksa.kube-system.namespace-controller
ksa.kube-system.node-controller
ksa.kube-system.nodelocaldns
ksa.kube-system.persistent-volume-binder
ksa.kube-system.pod-garbage-collector
ksa.kube-system.pv-protection-controller
ksa.kube-system.pvc-protection-controller
ksa.kube-system.replicaset-controller
ksa.kube-system.replication-controller
ksa.kube-system.resourcequota-controller
ksa.kube-system.root-ca-cert-publisher
ksa.kube-system.service-account-controller
ksa.kube-system.service-controller
ksa.kube-system.statefulset-controller
ksa.kube-system.token-cleaner
ksa.kube-system.ttl-after-finished-controller
ksa.kube-system.ttl-controller

root@debian11:~/12.5#
```

---

[^1]: CNI = Container Network Interface
