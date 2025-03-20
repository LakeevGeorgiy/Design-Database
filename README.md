# Design Database

Это проект был разработан в рамках дисциплины "Проектирование БД".

## Build
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

## Launch

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
