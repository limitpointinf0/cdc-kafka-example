from kafka import KafkaConsumer
import sys
import json
import datetime
import os

# Initialize consumer variable and set property for JSON decode
consumer = KafkaConsumer ('dbserver1.inventory.customers',bootstrap_servers = ['34.87.40.20:9092'],
value_deserializer=lambda m: json.loads(m.decode('utf-8')))

# Read data from kafka
for message in consumer:
    try:
        print(message[6])
        dt = datetime.datetime.now().strftime("%d_%m_%Y__%H_%M_%S")
        with open(f'data/data_{dt}.json', 'w') as f:
            json.dump(message[6], f, ensure_ascii=False, indent=4)
    except Exception as e:
        print(e)
        sys.exit()
# Terminate the script
sys.exit()