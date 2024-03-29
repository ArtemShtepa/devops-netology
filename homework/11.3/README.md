# Домашнее задание по лекции "11.3 Микросервисы: подходы"

> Вы работаете в крупной компанию, которая строит систему на основе микросервисной архитектуры.
> Вам как DevOps специалисту необходимо выдвинуть предложение по организации инфраструктуры, для разработки и эксплуатации.

## Обязательная задача 1: Обеспечить разработку

> Предложите решение для обеспечения процесса разработки: хранение исходного кода, непрерывная интеграция и непрерывная поставка. 
> Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.
> 
> Решение должно соответствовать следующим требованиям:
> - Облачная система;
> - Система контроля версий Git;
> - Репозиторий на каждый сервис;
> - Запуск сборки по событию из системы контроля версий;
> - Запуск сборки по кнопке с указанием параметров;
> - Возможность привязать настройки к каждой сборке;
> - Возможность создания шаблонов для различных конфигураций сборок;
> - Возможность безопасного хранения секретных данных: пароли, ключи доступа;
> - Несколько конфигураций для сборки из одного репозитория;
> - Кастомные шаги при сборке;
> - Собственные докер образы для сборки проектов;
> - Возможность развернуть агентов сборки на собственных серверах;
> - Возможность параллельного запуска нескольких сборок;
> - Возможность параллельного запуска тестов;
>
> Обоснуйте свой выбор.

### Решение: Omnibus версия GitLab Community Edition

Обоснование:
- **Community Edition** - без официальной поддержки, зато совершенно бесплатно. При этом **GitLab** обладает хорошей документацией, охватывающей все аспекты администрирования и использования
- **Omnibus** пакет содержит все необходимые компоненты для работы системы, обеспечивая простоту установки
- Образ **Docker** настоящая **killer feature**, которая помимо стандартных плюшек контейнеризации позволяет минимизировать временные затраты на обслуживание системы. Установка и обновление выполняется буквально в пару действий: `docker compose pull` и `docker compose up -d` - всё остальное, включая замену одних компонентов на другие и миграцию данных, GitLab сделает сам. Главное придерживаться рекомендуемого [плана смены версий](https://docs.gitlab.com/ee/update/index.html#upgrade-paths)
- Развернуть систему можно как в закрытой локальной сети предприятия, так и на собственном арендуемом сервере или на виртуальном хостинге
- **GitLab** подстроен на основе системы контроля версий [Git](https://docs.gitlab.com/ee/tutorials/#use-git)
- Неограниченное число [проектов](https://docs.gitlab.com/ee/user/project/), которые можно объединять в [группы](https://docs.gitlab.com/ee/user/group/). Для каждого проекта свой репозиторий
- Система имеет настройку прав доступа пользователям как ко всем проектам группы, так и отдельным проектам
- Для безопасного хранения секретных данных для CI/CD можно использовать [переменные](https://docs.gitlab.com/ee/ci/variables/), которые можно замаскировать в логах, либо [внешнее хранилище секретов](https://www.dmosk.ru/miniinstruktions.php?mini=gitlab-hashicorp-vault)
- [Планирование и отслеживание разработки](https://docs.gitlab.com/ee/topics/plan_and_track.html) - для каждого проекта ведётся учёт задач (**issue**), описывающих конкретные цели для изменения кода проекта - исправление ошибки, добавление нового или изменение текущего функционала.
- Задачи могут иметь различные статусы, в зависимости от которых они располагаются на **dashboard**, что позволяет наглядно оценить готовность проекта. Таким образом в системе можно реализовать [Agile методологии](https://habr.com/ru/company/hygger/blog/351048/)
- В системе реализован полноценный [CI/CD](https://docs.gitlab.com/ee/ci/), позволяющий автоматически запускать сборку при фиксировании изменений в репозитории.
- Созданные **pipeline** можно настроить и запускать в ручном режиме
- Для каждой **job** из **pipeline** можно задавать необходимые переменные с нужными значениями
- Все процессы **CI/CD** для каждого проекта описываются одним **YAML** файлом, где можно реализовать сколько угодно шаблонов с разными настройками и состоящих из любого числа шагов. Разумеется всё это прописываются вручную, что немного усложняет процесс настройки.
- Для **GitLab** нет разницы между терминами `сборка` и `запуск тестов` - это всё **job** прописанные в `.gitlab-ci.yml`
- Для сборки проектов используются образы **Docker**, которые могут собираться вручную и хранится в специальном [Registry](https://docs.gitlab.com/ee/user/packages/) самой системы
- В **Self-manager** версии доступно создание неограниченного числа агентов сборки или [Runner](https://docs.gitlab.com/runner/), которые будут непосредственно выполнять сборку проектов
- Располагать **runner** можно где угодно, в том числе на других серверах. И запускать в контейнерах **Docker**
- Чем больше доступных **runner** (не занятых работой), тем больше сборок можно выполнять параллельно.

Вместо **GitLab** можно использовать свои сервера **Git** и **Jenkins**

**Jenkins** позволяет:
- Использовать **Git** репозитории как основу для **CI/CD**
- Настраивать **pipeline** в разных стилях (**Freestyle**, декларативный, скриптовый), в том числе настраивать условия запуска сборки
- Все **pipeline** можно запускать вручную из интерфейса **Jenkins**
- Каждая **pipeline** может иметь переменные окружения и другие параметры, настраиваемые прямо в интерфейсе **Jenkins**
- Безопасно хранить секретные данные (текст или небольшие файлы)
- Позволяет создавать **multibranch pipeline**, фактически представлящий из себя несколько **pipeline** на основе веток одного репозитория
- Все типы **pipeline** допускают внедрение произвольных шагов (например, запуск скриптов)
- Позволяет [использовать Docker образы](https://www.jenkins.io/doc/book/pipeline/docker/) как для всего **pipeline**, так и для каждого шага в отдельности
- Допускает разворачивание любого числа агентов и **instance** сборки в них как на облачных ресурсах, так и собственных серверах
- Позволяет реализовать параллельный запуск сборок при наличии доступных **instance** агентов

---

## Обязательная задача 2: Логи

> Предложите решение для обеспечения сбора и анализа логов сервисов в микросервисной архитектуре.
> Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.
> 
> Решение должно соответствовать следующим требованиям:
> - Сбор логов в центральное хранилище со всех хостов обслуживающих систему;
> - Минимальные требования к приложениям, сбор логов из stdout;
> - Гарантированная доставка логов до центрального хранилища;
> - Обеспечение поиска и фильтрации по записям логов;
> - Обеспечение пользовательского интерфейса с возможностью предоставления доступа разработчикам для поиска по записям логов;
> - Возможность дать ссылку на сохраненный поиск по записям логов;
> 
> Обоснуйте свой выбор.

### Решение: Grafana Loki

Обоснование:
- Специально написанный для **Loki** сборщик логов **Promtail** использует такую же службу обнаружения как в **Prometheus** и включает аналогичные функции для маркировки, трансформации и фильтрации логов перед отправкой в хранилище;
- Решение написано на **Go** и изначально разрабатывалось как экономичное и горизонтально-масштабирумое решение;
- Данные перед отправкой фильтруются и сжимаются, но в угоду производительности индексируется не всё содержимое логов, а только выделенные **labels**;
- Решение совместимо с **FluentBit** и **Fluentd** (имеются соответствующие **output plugin**):
- Включает средство визуализации **Grafana** с поддержкой **LogQL** для анализа логов;
- Решение имеет родную интеграцию с **Prometheus** и **Kubernetes**;
- Поддерживаются механизмы оповещений через **AlertManager**.

В качестве альтернативы можно использовать менее эффективное, но более гибкое решение - стек **ELK**: **Elasticsearch** для хранения, **Logstash** или совместивые аналоги для сбора логов и **Kibana** в качестве анализотора и визуализатора 

---

## Обязательная задача 3: Мониторинг

> Предложите решение для обеспечения сбора и анализа состояния хостов и сервисов в микросервисной архитектуре.
> Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.
> 
> Решение должно соответствовать следующим требованиям:
> - Сбор метрик со всех хостов, обслуживающих систему;
> - Сбор метрик состояния ресурсов хостов: CPU, RAM, HDD, Network;
> - Сбор метрик потребляемых ресурсов для каждого сервиса: CPU, RAM, HDD, Network;
> - Сбор метрик, специфичных для каждого сервиса;
> - Пользовательский интерфейс с возможностью делать запросы и агрегировать информацию;
> - Пользовательский интерфейс с возможность настраивать различные панели для отслеживания состояния системы;
> 
> Обоснуйте свой выбор.

### Решение: Grafana + InfluxDB + Telegraf

Обснование:
- Визуализатор **Grafana** поддерживает множество источников данных, включая **Loki**, **Clickhouse**, **Elasticsearch**, **Prometheus** и другие
- **Grafana** имеет интуитивно понятный интерфест создания **dashboard** и панелей, а также коллекции уже готовых элементов, которые можно импортировать;
- При создании панели в зависимости от используемого источника данных интерфейс может меняться, например выбрав базу данных временных рядов **InfluxDB** в качестве источника данных интерфейс будет содержать весьма функциональный конструктор запроса данных;
- Для большинства источников данных поддерживаются функции фильтрации, трансформации и группировки данных;
- Сборщик метрик **Telegraf** построен по принципу **plugin** и уже имеет богатый набор всевозможных сборщиков и модулей вывода; также программа потребляет достаточно мало памяти;

---

## Дополнительная задача 4: Логи * (необязательная)

> Продолжить работу по задаче API Gateway: сервисы используемые в задаче пишут логи в stdout. 
> 
> Добавить в систему сервисы для сбора логов Vector + ElasticSearch + Kibana со всех сервисов обеспечивающих работу API.
> 
> В качестве решения приведите:
> 
> docker compose файл запустив который можно перейти по адресу http://localhost:8081 по которому доступна Kibana.
> Логин в Kibana должен быть admin пароль qwerty123456

---

## Задача 5: Мониторинг * (необязательная)

> Продолжить работу по задаче API Gateway: сервисы используемые в задаче предоставляют набор метрик в формате prometheus:
> 
> - Сервис security по адресу /metrics
> - Сервис uploader по адресу /metrics
> - Сервис storage (minio) по адресу /minio/v2/metrics/cluster
> 
> Добавить в систему сервисы для сбора метрик (Prometheus и Grafana) со всех сервисов обеспечивающих работу API.
> Построить в Grafana dashboard показывающий распределение запросов по сервисам.
> 
> В качестве решения приведите:
> 
> docker compose файл запустив который можно перейти по адресу http://localhost:8081 по которому доступна Grafana с настроенным Dashboard.
> Логин в Grafana должен быть admin пароль qwerty123456

