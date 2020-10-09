# Getting Started With Debezium and Kafka using Docker Compose
A simple docker compose for experimenting with Kafka and CDC with Debezium.

## Installation

You must install docker and docker-compose before you begin.
You may use the following script to install: https://gist.githubusercontent.com/limitpointinf0/6a9490ff4fef82a0b385d8a07c15a5c7/raw/5caf17d077fe5e17ffa2eba25fc5c0486e0b657d/install_docker.sh 

## Instructions:

    - docker-compose up -d zookeeper

    - docker-compose up -d kafka

    - docker-compose up -d mysql_kafka

    - docker-compose up -d connect

    - curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d '{ "name": "inventory-connector", "config": { "connector.class": "io.debezium.connector.mysql.MySqlConnector", "tasks.max": "1", "database.hostname": "mysql_kafka", "database.port": "3306", "database.user": "debezium", "database.password": "dbz", "database.server.id": "184054", "database.server.name": "dbserver1", "database.whitelist": "inventory", "database.history.kafka.bootstrap.servers": "kafka:9092", "database.history.kafka.topic": "dbhistory.inventory" } }'

    - docker compose up watcher

    - use a client to connect to the MySql
        - host: localhost
        - database: inventory
        - username: root
        - password: debezium
        - port: 3306

    - run the following queries:
        - insert into customers(first_name, last_name, email) values ('FIRST NAME', 'LAST NAME', 'YOUREMAIL@EMAIL.COM');
        - update customers set email='NEWEMAIL@acme.com' where id=1005;
        
    - check the output from the watcher container
