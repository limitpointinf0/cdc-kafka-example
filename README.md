# Getting Started With Debezium and Kafka using Docker Compose
A simple docker compose for experimenting with Kafka and CDC with Debezium.

## Installation

You must install docker and docker-compose before you begin.
You may use the following script to install: https://gist.githubusercontent.com/limitpointinf0/6a9490ff4fef82a0b385d8a07c15a5c7/raw/5caf17d077fe5e17ffa2eba25fc5c0486e0b657d/install_docker.sh 

## Local Demo
- Run all of the following to set up the full environment:
```bash
docker-compose up -d zookeeper

docker-compose up -d kafka

docker-compose up -d mysql_kafka

docker-compose up -d connect

curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d '{ "name": "inventory-connector", "config": { "connector.class": "io.debezium.connector.mysql.MySqlConnector", "tasks.max": "1", "database.hostname": "mysql_kafka", "database.port": "3306", "database.user": "debezium", "database.password": "dbz", "database.server.id": "184054", "database.server.name": "dbserver1", "database.whitelist": "inventory", "database.history.kafka.bootstrap.servers": "kafka:9092", "database.history.kafka.topic": "dbhistory.inventory" } }'

docker compose up watcher
```
- Use a client to connect to MySql with the following:
    - host: localhost
    - database: inventory
    - username: root
    - password: debezium
    - port: 3306
- Run the following queries:
```sql
insert into customers(first_name, last_name, email) values ('FIRST NAME', 'LAST NAME', 'YOUREMAIL@EMAIL.COM');

update customers set email='NEWEMAIL@acme.com' where id=1005;
```  
- Check the output from the watcher container.

## On-Prem to Cloud Demo

### Cloud 
- Set up Zookeeper and Kafka in a cloud VM.
    - Set host_public_IP for docker_compose_cloud.yaml
    - Run the following commands
```bash
cd cdc_prem_to_cloud

docker-compose -f docker_compose_cloud.yaml up -d zookeeper

docker-compose -f docker_compose_cloud.yaml up -d kafka
```
- Set up the consumer to output events to a JSON file with name as datetime.
    - Change IP to public IP of Kafka
    - Run the following script
```bash
python3 consumer.py
```
- Check for outputs in data folder after running on-prem steps.

### On-Prem
- Set up both MySQL and Debezium. 
    - Set kafka_public_IP in docker_compose_prem.yaml
    - Run the following commands
```bash
docker-compose -f docker_compose_prem.yaml up -d mysql_kafka

docker-compose -f docker_compose_prem.yaml up -d connect
```
- Make the following request and don't forget to set the KAFKA PUBLIC IP:
```bash
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d '{ "name": "inventory-connector", "config": { "connector.class": "io.debezium.connector.mysql.MySqlConnector", "tasks.max": "1", "database.hostname": "mysql_kafka", "database.port": "3306", "database.user": "debezium", "database.password": "dbz", "database.server.id": "184054", "database.server.name": "dbserver1", "database.whitelist": "inventory", "database.history.kafka.bootstrap.servers": "[KAFKA PUBLIC IP]:9092", "database.history.kafka.topic": "dbhistory.inventory" } }'
```
- Use a client to connect to MySql with the following:
    - host: localhost
    - database: inventory
    - username: root
    - password: debezium
    - port: 3306
- Run the following queries:
```sql
insert into customers(first_name, last_name, email) values ('FIRST NAME', 'LAST NAME', 'YOUREMAIL@EMAIL.COM');

update customers set email='NEWEMAIL@acme.com' where id=1005;
```
## Sources
[The 5 minute introduction to Log-Based Change Data Capture with Debezium](https://shekhargulati.com/2019/12/07/the-5-minute-introduction-to-log-based-change-data-capture-with-debezium/)
## License
[MIT](https://choosealicense.com/licenses/mit/)
