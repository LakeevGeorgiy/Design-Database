# Design Database

На основе нормализованной схемы разворачивается, используя идемпотентные файлы миграции, СУБД PostgreSQL внутри Docker контейнера. Так же через .env есть возможность передать версию (переменная "MIGRATION"), до которой будут происходить миграции. Если не указано, то до последней. В ластере СУБД создан пользователь, от его имени которого выполняются миграции.

После создания таблиц они заполняются тестовыми данными. Для этого в /docker-entrypoint-initdb.d/ написаны скрипты, которые выполняются автоматически при развертывании контейнера. Скрипт генерирует любое кол-во записей в зависимости от переменной "GENERATOR_CNT" в .env файле.

Также добавляются роли, которые имеют возможность подключения к
БД - это: reader, writer. Reader может только читать данные из таблиц, но не изменять их. Writer может читать и добавлять, изменять данные, но не может их удалять. Пользователь analytic может читать ровно одну таблицу. Создается групповая роль, зайти под которой в базу данных нельзя. Она имеет все возможности манипуляции над базой данных: запись новых данных, удаление и чтение. В файле .env передается переменная "USERS", которая содержит список имен пользователей, относящихся к этой группе с возможностью подключения к БД.

## Оптимизации

Для того, чтобы оценить и сравнить производительность различных запросов создаим сервис (Queries/service.sh), который будет вызывать Explain Analyze для каждого запроса и измерять Cost. Полученные результаты форматировать и записывать в отдельный файл: лучший, средний, худший случай для каждого запроса. (Кол-во попыток к каждому запросу определяется в env "ATTEMPTS").

Запросы:
1. Вывести топ 100 пользователей, у которых больше всего профит
2. Максимальный гэп в день
3. Все транзакции определенного пользователя
4. Количество пользователей совершивших транзакцию за месяц.
5. Ежегодная дивендная доходность за 5 лет по бумаге.

Далее добавляются индексы к отношениям (с помощью скрипта Indexes/indexes.sh), а также таблиции деляться на партиции (Partitiongs/partitions.sh). После каждого изменения текущего состояния БД вызывается сервис Queries/service.sh и результаты оптимизаций можно посмотреть в каталоге /Explain results.

Скрипт (Backups/backup.sh) создает бэкапы базы данных, каждые n-часов, последние m-бекапов хранятся, более старые удаляются (параметры передаются через env).

## Отказоустойчивость
Наконец, для отказоустойчивости кластера СУБД разворачиваются 2 реплики Postgres с использованием Patroni: при отказе мастера происходит автоматическое переключение.

## Мониторинг
Полезные данные экзспортируются в Prometheus, поднятый на порту 9090. В Grafana настроено соединение с Prometheus и налажен экспорт метрик. Для наглядности был выбран шаблонный Dashboard (id: 9628).


## Сборка
Для того, чтобы собрать и запустить локально необходимо:
* Склонировать репозиторий Patroni: 
```
git clone https://github.com/patroni/patroni.git
```

* Перейти в директрию: 
```
cd ./patroni
```

* Собрать Docker Image: 
```
docker build -t patroni .
```

## Запуск
Чтобы запустить локально необходимо:
* После этого вернуться в директорию проекта и запустить контейнеры: 
```
docker compose up -d
```

* Открыть командную строку контейнера haproxy: 
```
docker exec -it lab-haproxy bash
```

* Запустить создание нового кластера PostgreSql: 
```
cd /usr/lib/postgresql/16/bin/
./initdb
```

* Для сбора статистик добавить следующие строки в конфигурацию PostgreSql:
```
echo "shared_preload_libraries = 'pg_stat_statements'" >> $PGDATA/postgresql.conf
echo "pg_stat_statements.max = 10000" >> $PGDATA/postgresql.conf
echo "pg_stat_statements.track = all" >> $PGDATA/postgresql.conf

```
* Для накатывания миграций вызвать
```
./docker-entrypoint-initdb.d/1.sh
```

* Далее переходим в Graphana
```
http://localhost:3000
```

* Добавляем новое соединение и так-как Prometheus поднят в Docker, то server url будет выглядеть следующим образом:
```
http://host.docker.internal:9090
```

## P.S.
Более подробно можно прочитать ([тут](Project.pdf))