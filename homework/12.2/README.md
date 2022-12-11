# Домашнее задание по лекции "12.2 Команды для работы с Kubernetes"

> Кластер — это сложная система, с которой крайне редко работает один человек.
> Квалифицированный devops умеет наладить работу всей команды, занимающейся каким-либо сервисом.
> После знакомства с кластером вас попросили выдать доступ нескольким разработчикам.
> Помимо этого требуется служебный аккаунт для просмотра логов.

Версии используемого инструментария:

```console
root@debian11:~# crictl --version
crictl version v1.25.0
root@debian11:~# cri-dockerd --version
cri-dockerd 0.2.6 (HEAD)
root@debian11:~# conntrack --version
conntrack v1.4.6 (conntrack-tools)
root@debian11:~# kubectl version --client --output=yaml
clientVersion:
  buildDate: "2022-12-08T19:58:30Z"
  compiler: gc
  gitCommit: b46a3f887ca979b1a5d14fd39cb1af43e7e5d12d
  gitTreeState: clean
  gitVersion: v1.26.0
  goVersion: go1.19.4
  major: "1"
  minor: "26"
  platform: linux/amd64
kustomizeVersion: v4.5.7

root@debian11:~# minikube version
minikube version: v1.28.0
commit: 986b1ebd987211ed16f8cc10aed7d2c42fc8392f
root@debian11:~# minikube start --driver=none
😄  minikube v1.28.0 on Debian 11.5
✨  Using the none driver based on user configuration
👍  Starting control plane node minikube in cluster minikube
🤹  Running on localhost (CPUs=8, Memory=7956MB, Disk=15059MB) ...
ℹ️  OS release is Debian GNU/Linux 11 (bullseye)
🐳  Preparing Kubernetes v1.25.3 on Docker 20.10.21 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🤹  Configuring local host environment ...

❗  The 'none' driver is designed for experts who need to integrate with an existing VM
💡  Most users should use the newer 'docker' driver instead, which does not require root!
📘  For more information, see: https://minikube.sigs.k8s.io/docs/reference/drivers/none/

❗  kubectl and minikube configuration will be stored in /root
❗  To use kubectl or minikube commands as your own user, you may need to relocate them. For example, to overwrite your own settings, run:

    ▪ sudo mv /root/.kube /root/.minikube $HOME
    ▪ sudo chown -R $USER $HOME/.kube $HOME/.minikube

💡  This can also be done automatically by setting the env var CHANGE_MINIKUBE_NONE_USER=true
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: default-storageclass, storage-provisioner
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
root@debian11:~#
```

## Задание 1: Запуск пода из образа в деплойменте

> Для начала следует разобраться с прямым запуском приложений из консоли.
> Такой подход поможет быстро развернуть инструменты отладки в кластере.
> Требуется запустить деплоймент на основе образа из hello world уже через deployment.
> Сразу стоит запустить 2 копии приложения (replicas=2).
>
> Требования:
>  * пример из hello world запущен в качестве deployment
>  * количество реплик в deployment установлено в 2
>  * наличие deployment можно проверить командой kubectl get deployment
>  * наличие подов можно проверить командой kubectl get pods

Создание **deployment** выполняется командой **kubectl** по следующему шаблону: `kubectl create deployment <имя> --image=<образ> [параметры]`, где:
  - `<имя>` - название создаваемого **deployment**
  - `<образ>` - имя образа, который **deployment** будет разворачивать в **pod**
  - `[параметры]` - дополнительные параметры **deployment**, например число реплик - `--replicas=2`

### Решение:

```console
root@debian11:~# kubectl create deployment hello --image=k8s.gcr.io/echoserver:1.4 --replicas=2
deployment.apps/hello created
root@debian11:~# kubectl get deployment
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
hello   2/2     2            2           86s
root@debian11:~# kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
hello-56c75d54f7-r6dsk   1/1     Running   0          91s
hello-56c75d54f7-xfsc6   1/1     Running   0          91s
root@debian11:~#
```

---

## Задание 2: Просмотр логов для разработки

> Разработчикам крайне важно получать обратную связь от штатно работающего приложения и, еще важнее, об ошибках в его работе. 
> Требуется создать пользователя и выдать ему доступ на чтение конфигурации и логов подов в app-namespace.
> 
> Требования: 
>  * создан новый токен доступа для пользователя
>  * пользователь прописан в локальный конфиг (~/.kube/config, блок users)
>  * пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod <pod_id>)
>
> Посмотреть RBAC, Role, RoleBinding

### Решение

> При решении использовалась статься [Пользователи и авторизация RBAC в Kubernetes](https://habr.com/ru/company/flant/blog/470503/)

В решении используется авторизация пользователя `sa` на основе сертификатов.

#### Процесс создания сертицикатов состоит из нескольких шагов:

1. Генерирование секретного ключа и запись его в файл

  ```console
  root@debian11:~# openssl genrsa -out sa.key 4096
  Generating RSA private key, 4096 bit long modulus (2 primes)
  ...................++++
  ...........++++
  e is 65537 (0x010001)
  root@debian11:~#
  ```

2. Формирование **CERTIFICATE REQUEST** (открытый ключ)

  ```console
  root@debian11:~$ openssl req -new -key sa.key -out sa.csr -subj "/CN=sa"
  root@debian11:~$
  ```

3. Для формирования клиентского сертификата нужно заверить пользовательский открытый ключ в центре сертификации **Kubernetes** (в данном случае используются сертификаты, сгенерированные **minikube**)

  ```console
  root@debian11:~# openssl x509 -req -in sa.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out sa.crt -days 182
  Signature ok
  subject=CN = sa
  Getting CA Private Key
  root@debian11:~#
  ```

4. Перенос сертификата и секретного ключа в каталог пользователя

  ```console
  root@debian11:~# mkdir /home/sa/.certs && mv sa.{crt,key} /home/sa/.certs && chown sa:sa /home/sa/.certs/sa.* && echo OK
  OK
  root@debian11:~#
  ```

#### Создание пользователя `sa` в **minikube** и привязка к нему сертификата

```console
root@debian11:~# kubectl config set-credentials sa --client-certificate=/home/sa/.certs/sa.crt --client-key=/home/sa/.certs/sa.key
User "sa" set.
root@debian11:~#
```

#### Создание контекста `sa--context` для пользователя `sa` в кастере `minikube`

```console
root@debian11:~# kubectl config set-context sa-context --user=sa --cluster=minikube
Context "sa-context" created.
root@debian11:~#
```

Итоговый пример конфига для пользователя **sa** (`~/.kube/config`)

```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /root/.minikube/ca.crt
    extensions:
    - extension:
        last-update: Sat, 10 Dec 2022 15:48:32 EST
        provider: minikube.sigs.k8s.io
        version: v1.28.0
      name: cluster_info
    server: https://10.0.2.15:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    user: sa
  name: sa-context
current-context: sa-context
kind: Config
preferences: {}
users:
- name: sa
  user:
    client-certificate: /home/sa/.certs/sa.crt
    client-key: /home/sa/.certs/sa.key
```

Без назначения прав никакая информация недоступна, это можно проверить выполнив запрос от пользователя.
> При использовании **minikube**, контекст по умолчанию установлен в `minikube` и у него есть все права, поэтому нужно поменять на **свой** контекст.

```console
sa@debian11:~$ sudo kubectl config use-context sa-context
Switched to context "sa-context".
sa@debian11:~$ sudo kubectl get pods
Error from server (Forbidden): pods is forbidden: User "sa" cannot list resource "pods" in API group "" in the namespace "default"
sa@debian11:~$ sudo kubectl logs hello-56c75d54f7-bcgr4
Error from server (Forbidden): pods "hello-56c75d54f7-bcgr4" is forbidden: User "sa" cannot get resource "pods" in API group "" in the namespace "default"
sa@debian11:~$
```

#### Создание роли с правами `get,watch,list` на ресурсы `pods,pods/log`

```console
root@debian11:~# kubectl create role pod-rd --verb=get,watch,list --resource=pods,pods/log
role.rbac.authorization.k8s.io/pod-rd created
root@debian11:~#
```

#### Привязка роли к пользователю

```console
root@debian11:~# kubectl create rolebinding tester --role=pod-rd --user=sa
rolebinding.rbac.authorization.k8s.io/tester created
root@debian11:~#
```

#### Проверка функционирования роли пользователя `sa`:

> Проброс порта
> ```console
> root@debian11:~# kubectl expose deployment hello --type=LoadBalancer --port=8080
> service/hello exposed
> root@debian11:~# kubectl get services
> NAME         TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
> hello        LoadBalancer   10.100.45.82   <pending>     8080:32317/TCP   12s
> kubernetes   ClusterIP      10.96.0.1      <none>        443/TCP          175m
> ```
> Переключение контекста
> ```console
> root@debian11:~# kubectl config use-context sa-context
> Switched to context "sa-context".
> root@debian11:~#
> ```

```console
sa@debian11:~$ sudo kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
hello-56c75d54f7-bcgr4   1/1     Running   0          155m
hello-56c75d54f7-fjcm7   1/1     Running   0          155m
hello-56c75d54f7-r6dsk   1/1     Running   0          157m
hello-56c75d54f7-td8cv   1/1     Running   0          155m
hello-56c75d54f7-xfsc6   1/1     Running   0          157m
sa@debian11:~# kubectl logs hello-56c75d54f7-bcgr4
sa@debian11:~# kubectl logs hello-56c75d54f7-fjcm7
sa@debian11:~# kubectl logs hello-56c75d54f7-r6dsk
10.0.2.15 - - [10/Dec/2022:23:50:20 +0000] "GET / HTTP/1.1" 200 1721 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36 OPR/93.0.0.0 (Edition Yx)"
10.0.2.15 - - [10/Dec/2022:23:50:20 +0000] "GET /favicon.ico HTTP/1.1" 200 1655 "http://127.0.0.1:8080/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36 OPR/93.0.0.0 (Edition Yx)"
sa@debian11:~# kubectl logs hello-56c75d54f7-td8cv
sa@debian11:~# kubectl logs hello-56c75d54f7-xfsc6
sa@debian11:~$ sudo kubectl get deployment
Error from server (Forbidden): deployments.apps is forbidden: User "sa" cannot list resource "deployments" in API group "apps" in the namespace "default"
sa@debian11:~$
```

---

## Задание 3: Изменение количества реплик 

> Поработав с приложением, вы получили запрос на увеличение количества реплик приложения для нагрузки.
> Необходимо изменить запущенный deployment, увеличив количество реплик до 5.
> Посмотрите статус запущенных подов после увеличения реплик.
> 
> Требования:
>  * в deployment из задания 1 изменено количество реплик на 5
>  * проверить что все поды перешли в статус running (kubectl get pods)

Изменение какой-либо сущности в **Kubernates** производится:
  - Применением нового манифеста `kubectl apply -f <файл>`, где `<файл>` - файл конфигурации, который нужно применить.
  - "На лету" через изменение текущей конфигурации командой: `kubectl edit <сущность> <имя>`, где `<имя>` - имя изменяемой сущности типа `<сущность>` (например **deployment**).
При выполнении команды текущая конфигурация изменяемой сущности экспортируется во временный файл и откроется в редакторе.
После закрытия редактора **kubectl** применит манифест из данного временного файла.
  - Также "на лету" командой масштабирования `kubectl scale deployment <имя> --replicas=<число>`, где `<имя>` - название изменяемого **deployment**, а `<число>` - число реплик, которое должно быть развёрнуто

### Решение

```console
root@debian11:~# kubectl scale deployment hello --replicas=5
deployment.apps/hello scaled
root@debian11:~# kubectl get deployment hello
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
hello   5/5     5            5           2m15s
root@debian11:~# kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
hello-56c75d54f7-bcgr4   1/1     Running   0          21s
hello-56c75d54f7-fjcm7   1/1     Running   0          21s
hello-56c75d54f7-r6dsk   1/1     Running   0          2m26s
hello-56c75d54f7-td8cv   1/1     Running   0          21s
hello-56c75d54f7-xfsc6   1/1     Running   0          2m26s
root@debian11:~#
```
