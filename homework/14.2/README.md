# Домашнее задание по лекции "14.2 Синхронизация секретов с внешними сервисами. Vault"

## Основная задача 1: Работа с модулем Vault

Запустить модуль **Vault** конфигураций через утилиту **kubectl** в установленном ~minikube~ кластере **Kubernetes**.

Запуск **Vault** осуществляется в виде одиночного **pod** по следующему [манифесту](./src-simple/vault-pod.yml)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: netology-vault
spec:
  containers:
  - name: vault
    image: "vault:1.12.2"
    ports:
    - containerPort: 8200
      protocol: TCP
    env:
    - name: VAULT_DEV_ROOT_TOKEN_ID
      value: "vault-root-token"
    - name: VAULT_DEV_LISTEN_ADDRESS
      value: 0.0.0.0:8200
```

```console
root@debian11:~/14.2# kubectl apply -f vault-pod.yml
pod/netology-vault created
root@debian11:~/14.2#
```

Получить значение внутреннего IP пода

```console
root@debian11:~/14.2# kubectl get pod netology-vault -o json | jq -c '.status.podIPs'
[{"ip":"10.233.71.2"}]
root@debian11:~/14.2#
```

> **JQ** - утилита для работы с **JSON** в командной строке. [Страница установки](https://stedolan.github.io/jq/download/)

Запустить второй модуль для использования в качестве клиента

> Для второго модуля вместо **fedora** используется образ [python:slim](https://hub.docker.com/_/python/tags)

```console
root@debian11:~/14.2# kubectl run -i --tty python-slim --image=python:slim --restart=Never -- sh
If you don't see a command prompt, try pressing enter.

# pip install hvac
Collecting hvac
  Downloading hvac-1.0.2-py3-none-any.whl (143 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 143.5/143.5 kB 1.3 MB/s eta 0:00:00
Collecting pyhcl<0.5.0,>=0.4.4
  Downloading pyhcl-0.4.4.tar.gz (61 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.1/61.1 kB 23.0 MB/s eta 0:00:00
  Installing build dependencies ... done
  Getting requirements to build wheel ... done
  Preparing metadata (pyproject.toml) ... done
Collecting requests<3.0.0,>=2.27.1
  Downloading requests-2.28.2-py3-none-any.whl (62 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 62.8/62.8 kB 9.0 MB/s eta 0:00:00
Collecting charset-normalizer<4,>=2
  Downloading charset_normalizer-3.0.1-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (196 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 196.8/196.8 kB 4.9 MB/s eta 0:00:00
Collecting idna<4,>=2.5
  Downloading idna-3.4-py3-none-any.whl (61 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.5/61.5 kB 17.8 MB/s eta 0:00:00
Collecting urllib3<1.27,>=1.21.1
  Downloading urllib3-1.26.14-py2.py3-none-any.whl (140 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 140.6/140.6 kB 11.7 MB/s eta 0:00:00
Collecting certifi>=2017.4.17
  Downloading certifi-2022.12.7-py3-none-any.whl (155 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 155.3/155.3 kB 2.7 MB/s eta 0:00:00
Building wheels for collected packages: pyhcl
  Building wheel for pyhcl (pyproject.toml) ... done
  Created wheel for pyhcl: filename=pyhcl-0.4.4-py3-none-any.whl size=50127 sha256=b56a8751559c7598f7752c7182fa3a519e0e643c9c31f5c43ba1563b6787bbec
  Stored in directory: /root/.cache/pip/wheels/48/b1/7a/4f7e20dedcb202afa9006ad492bf20e446409da3f379f4952e
Successfully built pyhcl
Installing collected packages: pyhcl, charset-normalizer, urllib3, idna, certifi, requests, hvac
Successfully installed certifi-2022.12.7 charset-normalizer-3.0.1 hvac-1.0.2 idna-3.4 pyhcl-0.4.4 requests-2.28.2 urllib3-1.26.14
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv

[notice] A new release of pip available: 22.3.1 -> 23.0
[notice] To update, run: pip install --upgrade pip
#
```

Запустить интерпетатор **Python** и выполнить следующий код предварительно поменяв **IP** и токен

```python
import hvac
client = hvac.Client(url='http://127.0.0.1:8200', token='vault-access-token')
client.is_authenticated()
client.secrets.kv.v2.create_or_update_secret(path='hvac',secret=dict(netology='Big secret!!!'))
client.secrets.kv.v2.read_secret_version(path='hvac')
```

```console
# python
Python 3.11.2 (main, Feb  9 2023, 05:12:33) [GCC 10.2.1 20210110] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import hvac
>>> client = hvac.Client(url='http://10.233.71.2:8200', token='vault-root-token')
>>> client.is_authenticated()
True
>>> client.secrets.kv.v2.create_or_update_secret(path='hvac',secret=dict(netology='Big secret!!!'))
{'request_id': '5a65cd19-f8df-5cf5-c5d8-175e2c3cc4bd', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2023-02-12T12:11:35.800340054Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> client.secrets.kv.v2.read_secret_version(path='hvac')
{'request_id': '612ca165-fc42-f3e9-2998-a53be5af3108', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2023-02-12T12:11:35.800340054Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> exit()
# exit
root@debian11:~/14.2#
```

> Состояние кластера после выполнения заданий.
> **Pod**, запущенный командой **run** логично имеет статус завершенного (Completed)
> 
> ```console
> root@debian11:~/14.2# kubectl get pod,deploy,sts,svc -o wide
> NAME                 READY   STATUS      RESTARTS   AGE     IP            NODE    NOMINATED NODE   READINESS GATES
> pod/netology-vault   1/1     Running     0          3m56s   10.233.71.2   node3   <none>           <none>
> pod/python-slim      0/1     Completed   0          3m31s   10.233.75.4   node2   <none>           <none>
> 
> NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE     SELECTOR
> service/kubernetes   ClusterIP   10.233.0.1   <none>        443/TCP   6h55m   <none>
> root@debian11:~/14.2#
> ```

---

## Дополнительная задача 2 (*): Работа с секретами внутри модуля

* На основе образа fedora создать модуль;
* Создать секрет, в котором будет указан токен;
* Подключить секрет к модулю;
* Запустить модуль и проверить доступность сервиса Vault.

Для решения подготовлен манифест создания **pod** со следующим [содержимым](src-simple/fedora.yml)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: fedora
spec:
  restartPolicy: Never
  containers:
  - name: fedora
    image: "fedora"
    command:
    - bash
    - -c
    args:
    - |
      curl -s -v -H "X-Vault-Token: $MY_SECRET" -X GET http://10.233.71.2:8200/v1/secret/data/hvac
    env:
    - name: MY_SECRET
      valueFrom:
        secretKeyRef:
          name: vault-tkn
          key: token
  restartPolicy: Never
```

Создание секрета с токеном доступа к **Vault**

```console
root@debian11:~/14.2# kubectl create secret generic vault-tkn --from-literal=token=vault-root-token
secret/vault-tkn created
root@debian11:~/14.2# kubectl describe secret vault-tkn
Name:         vault-tkn
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
token:  16 bytes
root@debian11:~/14.2#
```

> Использовать **Root Token** крайне не рекомендуется,
> так как он предоставляет неограниченный доступ к управлению **Vault**,
> а данные секрета можно восстановить
> 
> ```console
> root@debian11:~/14.2# kubectl get secret vault-tkn -o json | jq -c -r .data.token | base64 -d && echo
> vault-root-token
> root@debian11:~/14.2#
> ```

Доступность **Vault** определяется по успешности запроса **Vault** секрета.
Подключение выполняется по **HTTP** к **API Vault** с использованием его **root token**,
переданного в переменную окружения через секрет **Kubernetes**.

```console
root@debian11:~/14.2# kubectl apply -f fedora.yml
pod/fedora created
root@debian11:~/14.2# kubectl logs pods/fedora
*   Trying 10.233.71.2:8200...
* Connected to 10.233.71.2 (10.233.71.2) port 8200 (#0)
> GET /v1/secret/data/hvac HTTP/1.1
> Host: 10.233.71.2:8200
> User-Agent: curl/7.85.0
> Accept: */*
> X-Vault-Token: vault-root-token
>
{"request_id":"62d47774-6430-7198-480c-eb7a35b4f459","lease_id":"","renewable":false,"lease_duration":0,"data":{"data":{"netology":"Big secret!!!"},"metadata":{"created_time":"2023-02-12T12:11:35.800340054Z","custom_metadata":null,"deletion_time":"","destroyed":false,"version":1}},"wrap_info":null,"warnings":null,"auth":null}
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Cache-Control: no-store
< Content-Type: application/json
< Strict-Transport-Security: max-age=31536000; includeSubDomains
< Date: Sun, 12 Feb 2023 12:23:34 GMT
< Content-Length: 328
<
{ [328 bytes data]
* Connection #0 to host 10.233.71.2 left intact
root@debian11:~/14.2#
```

---

## Дополнительные материалы

Инструмент управления кластерами **Kubernetes** в графическом интерфейсе: [OpenLens](https://github.com/MuhammedKalkan/OpenLens)

Репозиторий демонстраций **Сергея Андрюнина** [K8S Lessons](https://gitlab.com/k11s-os/k8s-lessons)

Документация по [Vault](https://developer.hashicorp.com/vault/tutorials/getting-started)
