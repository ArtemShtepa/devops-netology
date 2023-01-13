# Домашнее задание по лекции "14.1 Создание и использование секретов"

## Задача 1: Работа с секретами через утилиту kubectl в установленном minikube

> Выполните приведённые ниже команды в консоли, получите вывод команд.
> Сохраните задачу 1 как справочный материал.

Вместо **Minikube** использовался кластер из двух виртуальных машин, объеденённых в **NAT** сеть гипервизора **VirtualBox**.
Кластер состоит из: `1 Master` ноды и `1 Worker` ноды

### Как создать секрет?

Официальная документация Kubernetes: [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)

Генерирование сертификата:

```console
A:\>mkdir certs

A:\>openssl genrsa -out certs\cert.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
....................................................................................................................................++++
...................++++
e is 65537 (0x010001)

A:\>openssl req -x509 -new -key certs\cert.key -days 3650 -out certs\cert.crt -subj '/C=RU/ST=Moscow/L=Moscow/CN=server.local'

A:\>
```

Создание секрета типа **TLS**(сертификат) из командной строки: `kubectl create secret tls <имя> --cert=<файл сертификата (.crt)> --key=<файл ключа (.key)>`

```console
A:\>kubectl create secret tls domain-cert --cert=certs/cert.crt --key=certs/cert.key
secret/domain-cert created

A:\>
```

Создание **Generic** секрета из файлов с командной строки: `kubectl create secret generic <имя> --from-file=<имя файла с данными> ...`

```console
A:\>echo|set /P ="sa" > login

A:\>echo|set /P ="word" > password

A:\>kubectl create secret generic user-cred-file --from-file=login --from-file=password
secret/user-cred-file created

A:\>
```

> Имена полей секрета задающегося из файлов, включают расширение:
> ```console
> A:\>kubectl create secret generic test-file --from-file=test.txt
> secret/test-file created
> 
> A:\>kubectl describe secret test-file
> Name:         test-file
> Namespace:    default
> Labels:       <none>
> Annotations:  <none>
> 
> Type:  Opaque
> 
> Data
> ====
> test.txt:  10 bytes
> 
> A:\>
> ```

Создание секрета через манифест, например:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: user-cred-str
type: Opaque
stringData:
  login: "sa"
  password: "word"
```

```console
A:\>kubectl apply -f user-cred-str.yml
secret/user-cred-str created

A:\>
```

В отличии от **stringData**, содержащей человекочитаемые фразы, **data** может содержать любые символы, поэтому значения должны быть закодированы в **base64**

Подготовка фраз, кодированием строк в **base64**:

```console
A:\>echo|set /P ="sa"|base64
c2E=

A:\>echo|set /P ="word"|base64
d29yZA==

A:\>
```

Манифест создания **Generic** секрета из набора любых байт (**data**)

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: user-cred-data
type: Opaque
data:
  login: c2E=
  password: d29yZA==
```

```console
A:\>kubectl apply -f user-cred-data.yml
secret/user-cred-data created

A:\>
```

### Как просмотреть список секретов?

Команды `kubectl get secrets` и `kubectl get secret` эквивалентны

```console
A:\>kubectl get secrets
NAME             TYPE                DATA   AGE
domain-cert      kubernetes.io/tls   2      8m43s
user-cred-data   Opaque              2      19s
user-cred-file   Opaque              2      4m32s
user-cred-str    Opaque              2      3m40s

A:\>
```

### Как просмотреть секрет?

```console
A:\>kubectl get secret domain-cert
NAME          TYPE                DATA   AGE
domain-cert   kubernetes.io/tls   2      9m3s

A:\>kubectl describe secret domain-cert
Name:         domain-cert
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  kubernetes.io/tls

Data
====
tls.crt:  1944 bytes
tls.key:  3243 bytes

A:\>kubectl describe secret user-cred-data
Name:         user-cred-data
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
password:  4 bytes
login:     2 bytes

A:\>kubectl describe secret user-cred-str
Name:         user-cred-str
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
login:     2 bytes
password:  4 bytes

A:\>kubectl describe secret user-cred-file
Name:         user-cred-file
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
password:  4 bytes
login:     2 bytes

A:\>
```

### Как получить информацию в формате YAML и/или JSON?

Для получения информация по секрету в формате **YAML** нужно выполнить запрос секрета с ключом `-o yaml`

```console
A:\>kubectl get secret domain-cert -o yaml
apiVersion: v1
data:
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZiVENDQTFXZ0F3SUJBZ0lVQ3krN0ZHLzl0VkFISS9iMlRJWTg0WEVYdzkwd0RRWUpLb1pJaHZjTkFRRUwKQlFBd1JqRUxNQWtHQTFVRUJoTUNVbFV4RHpBTkJnTlZCQWdNQmsxdmMyTnZkekVQTUEwR0ExVUVCd3dHVFc5egpZMjkzTVJVd0V3WURWUVFEREF4elpYSjJaWEl1Ykc5allXd3dIaGNOTWpNd01URXpNRGcxT1RJd1doY05Nek13Ck1URXdNRGcxT1RJd1dqQkdNUXN3Q1FZRFZRUUdFd0pTVlRFUE1BMEdBMVVFQ0F3R1RXOXpZMjkzTVE4d0RRWUQKVlFRSERBWk5iM05qYjNjeEZUQVRCZ05WQkFNTURITmxjblpsY2k1c2IyTmhiRENDQWlJd0RRWUpLb1pJaHZjTgpBUUVCQlFBRGdnSVBBRENDQWdvQ2dnSUJBSjdBRXNaY0ViY3oyVWZlWUxzOUx6U0RnMTU1MGU0Q25sQmpaa1RKCjRBQ2JhS3NJVDVMcjhrM0dzQmt6WFlBRzJya1BMSTNZTzV0eGVEZWJzZHZjY0JNejVxMjZPV3ZDb29FeGEzYVQKcWtSbkNtbDFydWk4SVhvRC8zaFByVXBnU1hwV3VYOUFSNEs4Z0pvRFE1OHVZeDR3bTcvemZXWFYxanhQZ1QvaQoxcE1HdmtjV283QkR4cUd5SyttRW40Mlo4OVJEWXBNcCt6L2RXakVtVGVEeWlBZ3hsMjJyamJBYWJwaWhYMlM5CnE1MlErSkQzdU5VSmVkOTRQaCtISXpWQzFxb280a1Y5SnlIdjJiUXRBVythSUUzSWNqYjBwRFNacFV1SWxHYXUKeHRkdjByNm5FQlBlWGRYM1BaK1hCdTI4bEVyL3RmRFlDWXdpQWZaVmVsU0V1OHVieVBMajZkSVN5bThuV05UcwpQMzB2SHVlZk1hOFNCQW53ZUV2UmdlZ3BwUTA4QjJrYU50cFFrcG5EQ2c2cWRVYXNLNDMxczhiRzN2OUxQM0VKCnVXWSswaXJqU0p1cm1NenF2OGpueEVkZVQ1V2pWVGNjVTcwa0RxcVpIeGpJT3NYcEZLaDF2SlRCbW5qaCthOUEKaUYwT01iYnRPcXV6YXhwUkRVOG1jUnB6cU5nVkRzQnhJQXo0Zlp0aTdmZ3d6aWZDSUNJSUxNY3RqeXc3Nk5INQpaUDlkYVpaWXEyWHZvNFBxVk5FQTRDRGtxWTBKdmRlaUZCdDRHc1l5SFJ2OVQ3WmtDdWRqQi8vLy9MVVFReEwwCkx4OVB0aGt3Tm5xVkVkL1NzQTNGOTd4NmhWODdHa3Y4dVNhZ3U0M3dSamhkaHJaQjd0ZHhOSHJ1b2JlTCtORnQKaUh1M0FnTUJBQUdqVXpCUk1CMEdBMVVkRGdRV0JCU3FpSDhTUEtEWGFLa3F3ZTR1ZGtpVnNKZzc2ekFmQmdOVgpIU01FR0RBV2dCU3FpSDhTUEtEWGFLa3F3ZTR1ZGtpVnNKZzc2ekFQQmdOVkhSTUJBZjhFQlRBREFRSC9NQTBHCkNTcUdTSWIzRFFFQkN3VUFBNElDQVFBZVdKbjBhSlhnMTJxdGF5ODFWeUhZTllUTndQMzIvaDl6WFh3NkRvK2wKMkRIV25ucFBHbzVSWEh4ZXZ6T1k0T3g5YThDczN4cjhoeEgvRkx2ME5QOTd2c3ZIdFo4Zy9Yay9KdHgyRFFDQgpLRDVBN3FGU09VejcrRDNkbS9jc1FEM3VXRjhBaVRlVW91UFhVSGdmK1IrK0p3ckZXL2NwcHlLU0dUTGphOFVBCjkrNmpEVnRIT1hJRFh2RlQrSXJRRHdmbjhBazZ6cFRlM3BINkVYK1pYdWhnYS9HNGMyQmZWeUg2ZExGM2ZjUzYKR2tMMC90ZFRHcWZubkNUNG9VMStoSEllTGh5WVRERktGTjMxT0h2dytHWDM4dEtNTVhGMjZ1SmxYTGFxYVdWcwpCV2ZtaWlpbGE1a2Q2V1lQUXVseDlkMFUvZE41V2FjMGZDMEF2VTBtRmJlWGxRUGp2OXh5b0k4alFhVkJOZDdDCnYyNEFCQlNLT2NWMXBvOUtKVXJUcWxqL3VVRkpQSU5SMWJxZDdNZnFoeC9ocVZhUHJTcUlheWtBR3psQmJZYlMKYjlGaDZoSlNqWUViU2Z4bmdJVlI4ZzlQYXFzZ2ZyUnlWaTNhZ3lzVDV2cU1DR2UxandJbnVxZXNtTGpHamZtSQplUU4wQmUxUUpud1p1cG5qWjRpSEtkUDhWOTc0UUZxRERUaVdsaFZPWkI0c05GRHh1THd0OC9NcDR3YWYwQjhwCnh2SFhiTEtVSWRFZGJsTVVCbUdkd3JwV3AzNW0wanY4Rk9JczVjb1lEenAyMEFpTFBjTWVtZk85WXRjdzJxcUgKWWMwQjd6QUlwNFo1YmZ5c2t5TlBnbkdtMjBxbks3bmFKUTdCMUFpWFJaM1U4MU4zRWxVN3gzM3dRS0xWZFhuRApKdz09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
  tls.key: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKSndJQkFBS0NBZ0VBbnNBU3hsd1J0elBaUjk1Z3V6MHZOSU9EWG5uUjdnS2VVR05tUk1uZ0FKdG9xd2hQCmt1dnlUY2F3R1ROZGdBYmF1UThzamRnN20zRjRONXV4Mjl4d0V6UG1yYm81YThLaWdURnJkcE9xUkdjS2FYV3UKNkx3aGVnUC9lRSt0U21CSmVsYTVmMEJIZ3J5QW1nTkRueTVqSGpDYnYvTjlaZFhXUEUrQlArTFdrd2ErUnhhagpzRVBHb2JJcjZZU2ZqWm56MUVOaWt5bjdQOTFhTVNaTjRQS0lDREdYYmF1TnNCcHVtS0ZmWkwycm5aRDRrUGU0CjFRbDUzM2crSDRjak5VTFdxaWppUlgwbkllL1p0QzBCYjVvZ1RjaHlOdlNrTkptbFM0aVVacTdHMTIvU3ZxY1EKRTk1ZDFmYzluNWNHN2J5VVN2KzE4TmdKakNJQjlsVjZWSVM3eTV2STh1UHAwaExLYnlkWTFPdy9mUzhlNTU4eApyeElFQ2ZCNFM5R0I2Q21sRFR3SGFSbzIybENTbWNNS0RxcDFScXdyamZXenhzYmUvMHMvY1FtNVpqN1NLdU5JCm02dVl6T3EveU9mRVIxNVBsYU5WTnh4VHZTUU9xcGtmR01nNnhla1VxSFc4bE1HYWVPSDVyMENJWFE0eHR1MDYKcTdOckdsRU5UeVp4R25PbzJCVU93SEVnRFBoOW0yTHQrRERPSjhJZ0lnZ3N4eTJQTER2bzBmbGsvMTFwbGxpcgpaZStqZytwVTBRRGdJT1NwalFtOTE2SVVHM2dheGpJZEcvMVB0bVFLNTJNSC8vLzh0UkJERXZRdkgwKzJHVEEyCmVwVVIzOUt3RGNYM3ZIcUZYenNhUy95NUpxQzdqZkJHT0YyR3RrSHUxM0UwZXU2aHQ0djQwVzJJZTdjQ0F3RUEKQVFLQ0FnQVJ3MElXaWRTOW9BS081UllEdlZ2YnoxOVNvZVRZY2RpTy9DQkVVQ1pOU3haU0ZOTDZpSVlMSjlFcQpjTEhra2wvRTF5clFFRUxUS01ZZnlyOEM3ODVtaDZjbkJ6QkhtM2FkYUE4ekxHQ2YyTHUwZ3lONERSemR6emExCm1veTBSc1BSK1lRMTlkWktqWmNDSkoxYllWQmIzMnA5OXR1d0dsWW5WMm9KNFBMTGJyUzV0WkhKTmp3eWVZSXEKVmRtWWVZSnIzTUpaM3hlcTFMU3p6U3Bub2h1UWR5UVBkR09kTWNmd01oWS9hbTJhYXM4MVFWS2dHN2hVUmRzRgpvaFJSY0ZJZXBnWnphZ2FINkpOK2NvNjNreEpNUWNKdDNiL0YxdTlFM1ZwbGh1YmUwamROZDluM3J5am11UXhmCklBSDVkZUZONXdEUG13eXVibHV6MldxZnJGNXF3N3pGZkFjZFFnYi8rdEtSaXVqaEVNUDJVZm81M21DTTIxaEkKY3B1QjNZMlkyakp4OU1DcXRtQ1NnRzlIWUpaZWtkNWxnWkIvUktZMXZ5MzV1MFY1NU55S2JoZU1tSTQrU2lLdApkQ0JYK0ZSTk1ZTVh6dHhEbnIreTVUSVU5UWc5dGRzSGR6WldKUXgvVmVGbjJNWjA4UTA5QjhodkZoaXk5WU1JCksydjdIQTVTRXBmcmN0TlduRjJNZ3BVZGY5QXpFcDJNWlVGQ3FnY0FPV3lMQ1VEK0dkQlJoN0hWaGFabVExUUsKV1lJSWhNU3QxUGtRSEdDUHl1OHIzTW10TGNLcVFGd01oZTdFUFJLOXB4OUdaRjk4UmRiOFUrMmlLZlZlSzdWSwpQaEZBa2UrOG1OUFkyZFNLQ2NhV3lScWIzNjUyUUpadzVzTE1nejJ4MGs1L3BMQnd3UUtDQVFFQXk5OUpMRkZvCkxMMGE1SEx3ZEZDMmtqS2l6dzRESUZnNGRXNGk0UklFcVpieHpVaFpwZEJnaHlMSk16UkpLTkZBUnlheTIvdWsKOGdkaUp2VWJNeTJZNER3N25qaC9wRnd4dFcrTWNSTEVQaUJwZmk1MzZjS2xiSGdhYjhzd3VsZzM2TmlxdDhTSwpmOGdUVzdlTWhhQjhJYTRuTlc3c2EwTzkrTHh1S2ZrVWpTY2tBellKVXZSQWNnQzhRL2d4V3RCd1VkR0RGbllCCmd5b2hlNnJvSFVKUTVvK0ZKZXJUL2dsUFBUWFdwNFM3NHBLWUxDOE43YnVmMUdad2ZsUGFSSzBNZ0xZK2VVM3AKaUV4N3pldkZ3Z1l4SFRJK2cvN0dwZXAyQWtKTlN5UENwalRLMjk1eWNyK003Ri9JM0hGWWpub2VZQ3NNMEo5Rwo5NzFBZ3AvTGFtQXZWd0tDQVFFQXgxZEdWVjduNHVhdXlualJtWnRYRmZVUU5Hc3NrWjRGT004ckNhVG14NXNZCjVDenJQdE5Zak9SSDY5VVVjYklFeDhoT3dzcWtBaHJObFl6Z3p4Rm1UU1pyZGJxb3R2S2l6amtzc055V3IrYnMKaTF3ZE5xOEhlN1NIWnd6MmJ2YnpsbTNlQ09UbGhJT0ZHdnlqVmJCcVdYYS9EbHV3UUhJc0lEL3NZdHRLVytWdwpUNk9DalIvcUFCTjdCd1pBYnFwK1ZNK0xyaXgrWnlJdDVDTmRocXhTYVZ5V0VWMXFqRENJd0N2dzUyNGJFd096CkpBdk0xTUVSeGVJY0dlR09ROTFaR3BWMVI5N3lqTTlmb1htaXZVaUFpQkoxWFd6d1BUc0hWQmlBY081WW12SWcKcUlmY2pYUFR5TzhTdzdLZ3JoM2dXcytUQWV5Y0dnRmViS2hPc0pjNm9RS0NBUUJHbTl6UjlwZm45czdibEZ0bgpUWlVONlcrdDJxS0dqMGR1bEdpTUh4dHlTUThTRkI3SWFQVWxtSXlxcVU4MVRkTy9VTTNkbHJnNEF3cWhoMzZXCktSS3JodkQzQ1laYnZIcVM1a0Z6NEJZTGxsb3pFNUVBYXlPei81ellYejFQTE1LZ2FIb29EM0FRZFpFTzBQRmcKVG9idmUwdWxHL2ZSNXJKaTlaQUtCWFJ5dHIyb1J3elBxRHl4djBOMUh2Nm8vMHdIYWxMR2NyUnZZeVlabU1XdgpiSXBzY0FTamIwTmcxb1NWSkpKbGpua3NMYTE2a0FsNDd1U2FRYWh3ZUVZK1J0anZzeTdNQUlvRFpNbjBOZFpXCkxxTFFBOWpYQ21SdWpsZTB6SlhNa21RV0FHN0oyNjh6d3RmaC9nS3BKckNQR0FoeE1qZk1BWDRveTJrT1ZKMjEKQi84ZEFvSUJBREFuQmVkamFKSm45UHNWMmxQSHNXNnRadit5ais2UkJHUG5yMWJDRGJsVDN0eG5lV0FRdjRneApNS3BvSzJzWGZJNGg5ZHlhQktvNWZVWE41UlEvK0wxVU5Zc1h6dDk2bHhkSHVtTHl0amZCaVl4VWNQNGZvNmdmClFNSUU0SmFIY3VuNG1qVDl6ZStIc2FTR09KSmZiaUUwVFF5VDIyeUY1K0RXY0N5bEdqNCtteld4b3J5aVkrMG0KeDRZMzNXS2VMcXdnQW5iTmFxOVJFMUxUdENqdkFXMVFIelFNbzhzL2doa2h4Q3l6YlRqWG9QTnBJazZXWU11egpSZVIrbHRZUDV4RkQzelBBU0VqNVl2bG5uNGNudDF5blVOQ0RtemkvUkpMczVFSGpZV1gwYlMwb3ZIOHk1b3JZCkxXazJnaGZ0UVovT0dvM1JjUmZiRXNzZWtQdVpYR0VDZ2dFQUJmSUdyaFBZdnU1alVQTlhVbzhVS2NUU2xRTmEKS3hyS3NqSU0rWGFpMDc2cjhHMDRSUG5od1dRSjRqWi9yci9LSEZvbTRzK2crS25tc08vdHJZcVFaTkorS3ArcwpxdmIxTGFqaXhlUDVLVlRDRnVJZ1U5RE9Mek45eWJjNE5MMVlHY0hPM283L1MzT290eExFeHFOZE9rMWhpb1QyCkxzSThoOG9yNktJY1lDbi9FYzV2dXFJd2FIQ2NLMGQvUldJMlgwcER5UldMTURvL3BzZ0pBSnBwZlhrZEloNFUKVXFvc09iN3VtTzBwQjUvdnVRd2hNamdhNEtCWTV6MndjamlNenhSWXU0ejdPY2JDQ2lNb2d2dldJbXNNTWJKaQpGbXg4NWZTa1pHbHVISEwxeVk2YXJ5cWlVZHNialVaZkZGWjE0cXQvMEQyS3lYbVU4Z1E1QzZFTmxBPT0KLS0tLS1FTkQgUlNBIFBSSVZBVEUgS0VZLS0tLS0K
kind: Secret
metadata:
  creationTimestamp: "2023-01-13T09:00:25Z"
  name: domain-cert
  namespace: default
  resourceVersion: "30512"
  uid: 13b669b9-0ba1-4d5c-8944-2120f687dfc0
type: kubernetes.io/tls

A:\>kubectl get secret user-cred-str -o yaml
apiVersion: v1
data:
  login: c2E=
  password: d29yZA==
kind: Secret
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Secret","metadata":{"annotations":{},"name":"user-cred-str","namespace":"default"},"stringData":{"login":"sa","password":"word"},"type":"Opaque"}
  creationTimestamp: "2023-01-13T09:05:28Z"
  name: user-cred-str
  namespace: default
  resourceVersion: "30986"
  uid: 94404abe-45e9-4b40-a8fc-79c8b0fd70c5
type: Opaque

A:\>
```

Для получения информация по секрету в формате **JSON** нужно выполнить запрос секрета с ключом `-o json`

```console
A:\>kubectl get secret domain-cert -o json
{
    "apiVersion": "v1",
    "data": {
        "tls.crt": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZiVENDQTFXZ0F3SUJBZ0lVQ3krN0ZHLzl0VkFISS9iMlRJWTg0WEVYdzkwd0RRWUpLb1pJaHZjTkFRRUwKQlFBd1JqRUxNQWtHQTFVRUJoTUNVbFV4RHpBTkJnTlZCQWdNQmsxdmMyTnZkekVQTUEwR0ExVUVCd3dHVFc5egpZMjkzTVJVd0V3WURWUVFEREF4elpYSjJaWEl1Ykc5allXd3dIaGNOTWpNd01URXpNRGcxT1RJd1doY05Nek13Ck1URXdNRGcxT1RJd1dqQkdNUXN3Q1FZRFZRUUdFd0pTVlRFUE1BMEdBMVVFQ0F3R1RXOXpZMjkzTVE4d0RRWUQKVlFRSERBWk5iM05qYjNjeEZUQVRCZ05WQkFNTURITmxjblpsY2k1c2IyTmhiRENDQWlJd0RRWUpLb1pJaHZjTgpBUUVCQlFBRGdnSVBBRENDQWdvQ2dnSUJBSjdBRXNaY0ViY3oyVWZlWUxzOUx6U0RnMTU1MGU0Q25sQmpaa1RKCjRBQ2JhS3NJVDVMcjhrM0dzQmt6WFlBRzJya1BMSTNZTzV0eGVEZWJzZHZjY0JNejVxMjZPV3ZDb29FeGEzYVQKcWtSbkNtbDFydWk4SVhvRC8zaFByVXBnU1hwV3VYOUFSNEs4Z0pvRFE1OHVZeDR3bTcvemZXWFYxanhQZ1QvaQoxcE1HdmtjV283QkR4cUd5SyttRW40Mlo4OVJEWXBNcCt6L2RXakVtVGVEeWlBZ3hsMjJyamJBYWJwaWhYMlM5CnE1MlErSkQzdU5VSmVkOTRQaCtISXpWQzFxb280a1Y5SnlIdjJiUXRBVythSUUzSWNqYjBwRFNacFV1SWxHYXUKeHRkdjByNm5FQlBlWGRYM1BaK1hCdTI4bEVyL3RmRFlDWXdpQWZaVmVsU0V1OHVieVBMajZkSVN5bThuV05UcwpQMzB2SHVlZk1hOFNCQW53ZUV2UmdlZ3BwUTA4QjJrYU50cFFrcG5EQ2c2cWRVYXNLNDMxczhiRzN2OUxQM0VKCnVXWSswaXJqU0p1cm1NenF2OGpueEVkZVQ1V2pWVGNjVTcwa0RxcVpIeGpJT3NYcEZLaDF2SlRCbW5qaCthOUEKaUYwT01iYnRPcXV6YXhwUkRVOG1jUnB6cU5nVkRzQnhJQXo0Zlp0aTdmZ3d6aWZDSUNJSUxNY3RqeXc3Nk5INQpaUDlkYVpaWXEyWHZvNFBxVk5FQTRDRGtxWTBKdmRlaUZCdDRHc1l5SFJ2OVQ3WmtDdWRqQi8vLy9MVVFReEwwCkx4OVB0aGt3Tm5xVkVkL1NzQTNGOTd4NmhWODdHa3Y4dVNhZ3U0M3dSamhkaHJaQjd0ZHhOSHJ1b2JlTCtORnQKaUh1M0FnTUJBQUdqVXpCUk1CMEdBMVVkRGdRV0JCU3FpSDhTUEtEWGFLa3F3ZTR1ZGtpVnNKZzc2ekFmQmdOVgpIU01FR0RBV2dCU3FpSDhTUEtEWGFLa3F3ZTR1ZGtpVnNKZzc2ekFQQmdOVkhSTUJBZjhFQlRBREFRSC9NQTBHCkNTcUdTSWIzRFFFQkN3VUFBNElDQVFBZVdKbjBhSlhnMTJxdGF5ODFWeUhZTllUTndQMzIvaDl6WFh3NkRvK2wKMkRIV25ucFBHbzVSWEh4ZXZ6T1k0T3g5YThDczN4cjhoeEgvRkx2ME5QOTd2c3ZIdFo4Zy9Yay9KdHgyRFFDQgpLRDVBN3FGU09VejcrRDNkbS9jc1FEM3VXRjhBaVRlVW91UFhVSGdmK1IrK0p3ckZXL2NwcHlLU0dUTGphOFVBCjkrNmpEVnRIT1hJRFh2RlQrSXJRRHdmbjhBazZ6cFRlM3BINkVYK1pYdWhnYS9HNGMyQmZWeUg2ZExGM2ZjUzYKR2tMMC90ZFRHcWZubkNUNG9VMStoSEllTGh5WVRERktGTjMxT0h2dytHWDM4dEtNTVhGMjZ1SmxYTGFxYVdWcwpCV2ZtaWlpbGE1a2Q2V1lQUXVseDlkMFUvZE41V2FjMGZDMEF2VTBtRmJlWGxRUGp2OXh5b0k4alFhVkJOZDdDCnYyNEFCQlNLT2NWMXBvOUtKVXJUcWxqL3VVRkpQSU5SMWJxZDdNZnFoeC9ocVZhUHJTcUlheWtBR3psQmJZYlMKYjlGaDZoSlNqWUViU2Z4bmdJVlI4ZzlQYXFzZ2ZyUnlWaTNhZ3lzVDV2cU1DR2UxandJbnVxZXNtTGpHamZtSQplUU4wQmUxUUpud1p1cG5qWjRpSEtkUDhWOTc0UUZxRERUaVdsaFZPWkI0c05GRHh1THd0OC9NcDR3YWYwQjhwCnh2SFhiTEtVSWRFZGJsTVVCbUdkd3JwV3AzNW0wanY4Rk9JczVjb1lEenAyMEFpTFBjTWVtZk85WXRjdzJxcUgKWWMwQjd6QUlwNFo1YmZ5c2t5TlBnbkdtMjBxbks3bmFKUTdCMUFpWFJaM1U4MU4zRWxVN3gzM3dRS0xWZFhuRApKdz09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K",
        "tls.key": "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKSndJQkFBS0NBZ0VBbnNBU3hsd1J0elBaUjk1Z3V6MHZOSU9EWG5uUjdnS2VVR05tUk1uZ0FKdG9xd2hQCmt1dnlUY2F3R1ROZGdBYmF1UThzamRnN20zRjRONXV4Mjl4d0V6UG1yYm81YThLaWdURnJkcE9xUkdjS2FYV3UKNkx3aGVnUC9lRSt0U21CSmVsYTVmMEJIZ3J5QW1nTkRueTVqSGpDYnYvTjlaZFhXUEUrQlArTFdrd2ErUnhhagpzRVBHb2JJcjZZU2ZqWm56MUVOaWt5bjdQOTFhTVNaTjRQS0lDREdYYmF1TnNCcHVtS0ZmWkwycm5aRDRrUGU0CjFRbDUzM2crSDRjak5VTFdxaWppUlgwbkllL1p0QzBCYjVvZ1RjaHlOdlNrTkptbFM0aVVacTdHMTIvU3ZxY1EKRTk1ZDFmYzluNWNHN2J5VVN2KzE4TmdKakNJQjlsVjZWSVM3eTV2STh1UHAwaExLYnlkWTFPdy9mUzhlNTU4eApyeElFQ2ZCNFM5R0I2Q21sRFR3SGFSbzIybENTbWNNS0RxcDFScXdyamZXenhzYmUvMHMvY1FtNVpqN1NLdU5JCm02dVl6T3EveU9mRVIxNVBsYU5WTnh4VHZTUU9xcGtmR01nNnhla1VxSFc4bE1HYWVPSDVyMENJWFE0eHR1MDYKcTdOckdsRU5UeVp4R25PbzJCVU93SEVnRFBoOW0yTHQrRERPSjhJZ0lnZ3N4eTJQTER2bzBmbGsvMTFwbGxpcgpaZStqZytwVTBRRGdJT1NwalFtOTE2SVVHM2dheGpJZEcvMVB0bVFLNTJNSC8vLzh0UkJERXZRdkgwKzJHVEEyCmVwVVIzOUt3RGNYM3ZIcUZYenNhUy95NUpxQzdqZkJHT0YyR3RrSHUxM0UwZXU2aHQ0djQwVzJJZTdjQ0F3RUEKQVFLQ0FnQVJ3MElXaWRTOW9BS081UllEdlZ2YnoxOVNvZVRZY2RpTy9DQkVVQ1pOU3haU0ZOTDZpSVlMSjlFcQpjTEhra2wvRTF5clFFRUxUS01ZZnlyOEM3ODVtaDZjbkJ6QkhtM2FkYUE4ekxHQ2YyTHUwZ3lONERSemR6emExCm1veTBSc1BSK1lRMTlkWktqWmNDSkoxYllWQmIzMnA5OXR1d0dsWW5WMm9KNFBMTGJyUzV0WkhKTmp3eWVZSXEKVmRtWWVZSnIzTUpaM3hlcTFMU3p6U3Bub2h1UWR5UVBkR09kTWNmd01oWS9hbTJhYXM4MVFWS2dHN2hVUmRzRgpvaFJSY0ZJZXBnWnphZ2FINkpOK2NvNjNreEpNUWNKdDNiL0YxdTlFM1ZwbGh1YmUwamROZDluM3J5am11UXhmCklBSDVkZUZONXdEUG13eXVibHV6MldxZnJGNXF3N3pGZkFjZFFnYi8rdEtSaXVqaEVNUDJVZm81M21DTTIxaEkKY3B1QjNZMlkyakp4OU1DcXRtQ1NnRzlIWUpaZWtkNWxnWkIvUktZMXZ5MzV1MFY1NU55S2JoZU1tSTQrU2lLdApkQ0JYK0ZSTk1ZTVh6dHhEbnIreTVUSVU5UWc5dGRzSGR6WldKUXgvVmVGbjJNWjA4UTA5QjhodkZoaXk5WU1JCksydjdIQTVTRXBmcmN0TlduRjJNZ3BVZGY5QXpFcDJNWlVGQ3FnY0FPV3lMQ1VEK0dkQlJoN0hWaGFabVExUUsKV1lJSWhNU3QxUGtRSEdDUHl1OHIzTW10TGNLcVFGd01oZTdFUFJLOXB4OUdaRjk4UmRiOFUrMmlLZlZlSzdWSwpQaEZBa2UrOG1OUFkyZFNLQ2NhV3lScWIzNjUyUUpadzVzTE1nejJ4MGs1L3BMQnd3UUtDQVFFQXk5OUpMRkZvCkxMMGE1SEx3ZEZDMmtqS2l6dzRESUZnNGRXNGk0UklFcVpieHpVaFpwZEJnaHlMSk16UkpLTkZBUnlheTIvdWsKOGdkaUp2VWJNeTJZNER3N25qaC9wRnd4dFcrTWNSTEVQaUJwZmk1MzZjS2xiSGdhYjhzd3VsZzM2TmlxdDhTSwpmOGdUVzdlTWhhQjhJYTRuTlc3c2EwTzkrTHh1S2ZrVWpTY2tBellKVXZSQWNnQzhRL2d4V3RCd1VkR0RGbllCCmd5b2hlNnJvSFVKUTVvK0ZKZXJUL2dsUFBUWFdwNFM3NHBLWUxDOE43YnVmMUdad2ZsUGFSSzBNZ0xZK2VVM3AKaUV4N3pldkZ3Z1l4SFRJK2cvN0dwZXAyQWtKTlN5UENwalRLMjk1eWNyK003Ri9JM0hGWWpub2VZQ3NNMEo5Rwo5NzFBZ3AvTGFtQXZWd0tDQVFFQXgxZEdWVjduNHVhdXlualJtWnRYRmZVUU5Hc3NrWjRGT004ckNhVG14NXNZCjVDenJQdE5Zak9SSDY5VVVjYklFeDhoT3dzcWtBaHJObFl6Z3p4Rm1UU1pyZGJxb3R2S2l6amtzc055V3IrYnMKaTF3ZE5xOEhlN1NIWnd6MmJ2YnpsbTNlQ09UbGhJT0ZHdnlqVmJCcVdYYS9EbHV3UUhJc0lEL3NZdHRLVytWdwpUNk9DalIvcUFCTjdCd1pBYnFwK1ZNK0xyaXgrWnlJdDVDTmRocXhTYVZ5V0VWMXFqRENJd0N2dzUyNGJFd096CkpBdk0xTUVSeGVJY0dlR09ROTFaR3BWMVI5N3lqTTlmb1htaXZVaUFpQkoxWFd6d1BUc0hWQmlBY081WW12SWcKcUlmY2pYUFR5TzhTdzdLZ3JoM2dXcytUQWV5Y0dnRmViS2hPc0pjNm9RS0NBUUJHbTl6UjlwZm45czdibEZ0bgpUWlVONlcrdDJxS0dqMGR1bEdpTUh4dHlTUThTRkI3SWFQVWxtSXlxcVU4MVRkTy9VTTNkbHJnNEF3cWhoMzZXCktSS3JodkQzQ1laYnZIcVM1a0Z6NEJZTGxsb3pFNUVBYXlPei81ellYejFQTE1LZ2FIb29EM0FRZFpFTzBQRmcKVG9idmUwdWxHL2ZSNXJKaTlaQUtCWFJ5dHIyb1J3elBxRHl4djBOMUh2Nm8vMHdIYWxMR2NyUnZZeVlabU1XdgpiSXBzY0FTamIwTmcxb1NWSkpKbGpua3NMYTE2a0FsNDd1U2FRYWh3ZUVZK1J0anZzeTdNQUlvRFpNbjBOZFpXCkxxTFFBOWpYQ21SdWpsZTB6SlhNa21RV0FHN0oyNjh6d3RmaC9nS3BKckNQR0FoeE1qZk1BWDRveTJrT1ZKMjEKQi84ZEFvSUJBREFuQmVkamFKSm45UHNWMmxQSHNXNnRadit5ais2UkJHUG5yMWJDRGJsVDN0eG5lV0FRdjRneApNS3BvSzJzWGZJNGg5ZHlhQktvNWZVWE41UlEvK0wxVU5Zc1h6dDk2bHhkSHVtTHl0amZCaVl4VWNQNGZvNmdmClFNSUU0SmFIY3VuNG1qVDl6ZStIc2FTR09KSmZiaUUwVFF5VDIyeUY1K0RXY0N5bEdqNCtteld4b3J5aVkrMG0KeDRZMzNXS2VMcXdnQW5iTmFxOVJFMUxUdENqdkFXMVFIelFNbzhzL2doa2h4Q3l6YlRqWG9QTnBJazZXWU11egpSZVIrbHRZUDV4RkQzelBBU0VqNVl2bG5uNGNudDF5blVOQ0RtemkvUkpMczVFSGpZV1gwYlMwb3ZIOHk1b3JZCkxXazJnaGZ0UVovT0dvM1JjUmZiRXNzZWtQdVpYR0VDZ2dFQUJmSUdyaFBZdnU1alVQTlhVbzhVS2NUU2xRTmEKS3hyS3NqSU0rWGFpMDc2cjhHMDRSUG5od1dRSjRqWi9yci9LSEZvbTRzK2crS25tc08vdHJZcVFaTkorS3ArcwpxdmIxTGFqaXhlUDVLVlRDRnVJZ1U5RE9Mek45eWJjNE5MMVlHY0hPM283L1MzT290eExFeHFOZE9rMWhpb1QyCkxzSThoOG9yNktJY1lDbi9FYzV2dXFJd2FIQ2NLMGQvUldJMlgwcER5UldMTURvL3BzZ0pBSnBwZlhrZEloNFUKVXFvc09iN3VtTzBwQjUvdnVRd2hNamdhNEtCWTV6MndjamlNenhSWXU0ejdPY2JDQ2lNb2d2dldJbXNNTWJKaQpGbXg4NWZTa1pHbHVISEwxeVk2YXJ5cWlVZHNialVaZkZGWjE0cXQvMEQyS3lYbVU4Z1E1QzZFTmxBPT0KLS0tLS1FTkQgUlNBIFBSSVZBVEUgS0VZLS0tLS0K"
    },
    "kind": "Secret",
    "metadata": {
        "creationTimestamp": "2023-01-13T09:00:25Z",
        "name": "domain-cert",
        "namespace": "default",
        "resourceVersion": "30512",
        "uid": "13b669b9-0ba1-4d5c-8944-2120f687dfc0"
    },
    "type": "kubernetes.io/tls"
}

A:\>kubectl get secret user-cred-data -o json
{
    "apiVersion": "v1",
    "data": {
        "login": "c2E=",
        "password": "d29yZA=="
    },
    "kind": "Secret",
    "metadata": {
        "annotations": {
            "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"data\":{\"login\":\"c2E=\",\"password\":\"d29yZA==\"},\"kind\":\"Secret\",\"metadata\":{\"annotations\":{},\"name\":\"user-cred-data\",\"namespace\":\"default\"},\"type\":\"Opaque\"}\n"
        },
        "creationTimestamp": "2023-01-13T09:08:49Z",
        "name": "user-cred-data",
        "namespace": "default",
        "resourceVersion": "31287",
        "uid": "70cfc2e4-e7a3-498f-bbbd-e2ac6db9a109"
    },
    "type": "Opaque"
}

A:\>
```

### Как выгрузить секрет и сохранить его в файл?

Для того чтобы выгрузить секрет в файл достаточно перенаправить вывод, например:

Выгрузка всех секретов в формате **JSON**:

```console
kubectl get secrets -o json > secrets.yaml
```

Выгрузка конкретного секрета в **YAML** формат:

```console
kubectl get secret domain-cert -o yaml > domain-cert.yml
```

### Как удалить секрет?

Удаление секрета выполняется командой: `kubectl delete secret <имя>`, но нужно учитывать **namespace** секрета и если он отличается от выбранного в текущем контексте, нужно добавить ключ `-n <namespace>`

```console
A:\>kubectl delete secret domain-cert
secret "domain-cert" deleted

A:\>
```

### Как загрузить секрет из файла?

Выгрузка секрета из файла вполняется стандартным применением манифеста: `kubectl apply -f <файл манифеста>`

```console
A:\>kubectl apply -f domain-cert.yml
secret/domain-cert created

A:\>
```

## Дополнительная задача 2 (*): Работа с секретами внутри модуля

> Выберите любимый образ контейнера, подключите секреты и проверьте их доступность
> как в виде переменных окружения, так и в виде примонтированного тома.

Манифест **deploy** образа **Multitool**:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: mt-alpine
  name: mt-alpine
spec:
  selector:
    matchLabels:
      app: mt-alpine
  template:
    metadata:
      labels:
        app: mt-alpine
    spec:
      containers:
        - name: main-mt
          image: praqma/network-multitool:alpine-extra
          imagePullPolicy: IfNotPresent
          env:
            - name: SECRET_ENV_LOGIN
              valueFrom:
                secretKeyRef:
                  name: user-cred-str
                  key: login
            - name: SECRET_ENV_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: user-cred-data
                  key: password
          volumeMounts:
            - name: secret-tls
              mountPath: /tmp/cert
      volumes:
      - name: secret-tls
        secret:
          secretName: domain-cert
```

Список ресурсов (**deploy**, **pods**, **secrets**) кластера:

```console
A:\>kubectl get deploy,pods,secrets
NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mt-alpine   1/1     1            1           24s

NAME                             READY   STATUS    RESTARTS   AGE
pod/mt-alpine-7fff4f67cb-lqqlz   1/1     Running   0          24s

NAME                    TYPE                DATA   AGE
secret/domain-cert      kubernetes.io/tls   2      3m55s
secret/user-cred-data   Opaque              2      9m47s
secret/user-cred-file   Opaque              2      14m
secret/user-cred-str    Opaque              2      13m

A:\>
```

Просмотр ссылки на секрет через переменные окружения:

```console
A:\>kubectl exec pod/mt-alpine-7fff4f67cb-lqqlz -- env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=mt-alpine-7fff4f67cb-lqqlz
SECRET_ENV_LOGIN=sa
SECRET_ENV_PASSWORD=word
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.233.0.1
KUBERNETES_SERVICE_HOST=10.233.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://10.233.0.1:443
KUBERNETES_PORT_443_TCP=tcp://10.233.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
HOME=/root

A:\>
```

Просмотр ссылки на секрет, используемый как точка монтирования:

```console
A:\>kubectl exec pod/mt-alpine-7fff4f67cb-lqqlz -- ls /tmp/cert
tls.crt
tls.key

A:\>kubectl exec pod/mt-alpine-7fff4f67cb-lqqlz -- cat /tmp/cert/tls.crt
-----BEGIN CERTIFICATE-----
MIIFbTCCA1WgAwIBAgIUHKAl7t0mgVSMrY5jZq3GgodigT8wDQYJKoZIhvcNAQEL
BQAwRjELMAkGA1UEBhMCUlUxDzANBgNVBAgMBk1vc2NvdzEPMA0GA1UEBwwGTW9z
Y293MRUwEwYDVQQDDAxzZXJ2ZXIubG9jYWwwHhcNMjMwMTEyMTQ0NzUzWhcNMzMw
MTA5MTQ0NzUzWjBGMQswCQYDVQQGEwJSVTEPMA0GA1UECAwGTW9zY293MQ8wDQYD
VQQHDAZNb3Njb3cxFTATBgNVBAMMDHNlcnZlci5sb2NhbDCCAiIwDQYJKoZIhvcN
AQEBBQADggIPADCCAgoCggIBALB5UqBfSVTUKBcGgjvQYQ8wM6jtCQj58hBZDgjL
THovE6xwhclhS6GoFPVCioy2xyAhhsFl1Zkydk1Bv0ddg09+NOdKwRURIOHNFoeR
b5lO60YcY8p/ikBcsZ0hUXRnvvV/xonJAajm2nzCIgxvGJz2hxI7NR1hepgRhELM
OcEzE11dZ2/89uxouarolBqQgbn9oniPS5KR43h10ZKxXnsvH6BoPkyeOINzqX5O
qJ9fdtoOq+ormUT56lofBYirw3l0Pln4kZ7QRwDivzdsC1oyKoPIWp3XGQSTpLKn
XvuoAHe0W0Xqv94Drafm8m6L6dWU6QEntwI/ILgw8PgRBrN1rMtjGszMrsUq/A7k
lX4NuzmeGlOVWuLSfp2iEujtOV4WvNdVauDTZIX4XzWfKOvRlEkL/Q0sQ+JQhu6+
jpiFKKz49/T2qxKTYA53/nwhO3m9lQ5e3nP6MQ4TVHkm2e66/oCr9d0FJTO3Oiva
eQmmnDsnWMzNvvQUhfAvf2ERnavHNFxzwjnM6KERc2NHsO37lroh+FgLlDZzRf2O
1W+aa4M01G3kVuHUS93HzGUYVjhxj7nQ1z559QqkgCK5HCxs3G8HlGpzJvn8MO8W
jN057N7Poqa+zs3LZURO/8N7xnoogjtmnMpLny7v1HLmtzKJnNmT7noRgstEjoeu
727rAgMBAAGjUzBRMB0GA1UdDgQWBBTRUCr8uSplAwvS46PBW8Y78IKuiTAfBgNV
HSMEGDAWgBTRUCr8uSplAwvS46PBW8Y78IKuiTAPBgNVHRMBAf8EBTADAQH/MA0G
CSqGSIb3DQEBCwUAA4ICAQCl1z5gRXoHRnnBNSMCyqq0LycPsPvvELSjKFKfOXjz
JlP7zVe1FKoCGhm15ktEzEfOTx9iV4FqlAijaaDuXffscwvk9FCv8JXBZ0+e9ti7
zmGXU2OBECE09X4uk8N6OkO8GZpK40cS2jXHDdVCBhJCqaZwZUD8QWQyU11SZSiX
nnDFYagSGsX7HjWbGN3evmSLx3W4B1kAU23F9NzQ/h+5Yxv2ZvBblCLmF5sH7Rty
sAuZHDen1lN13A+/GF+ho9jS8E1NIAFkQ/N77e5yyOtx8yZi8TnrT1hZn4WRTBHZ
DXWjr1PfSY6EEQsA9WnredqkMHn/XldjzbZqepYmhGQaDEkUSuas2IbHx61DtKTx
gU7jTRQDSvGtDlktijuD55mKRj62GO3LbVbZaLP3xCblDaAwrxRG2l3J5Wo5FbzE
3RjviJ9D5NI62cvWkTCPgJfiZdWeQ9qeI7/DEgB9yEYeBjK6RC/GAL0RORMpWCHj
MnkonbkHguDYWszV+uO1Sg3p1qaVbEmXzhaf9HolSTl3gSypJyBTEipYr7MXzHmU
1cAzw26frlPtLxSDk68n+zauCHH0u44cl2NhqBXy+ivqd0/Trx7RcjCjCkj+w3Gx
IuozEqB1FELX7kbviqDq5NNUMNUSh/O33AnfBkzL3eZ9xD2SsjaUAJ9Y/JQ8DYCk
TQ==
-----END CERTIFICATE-----

A:\>
```