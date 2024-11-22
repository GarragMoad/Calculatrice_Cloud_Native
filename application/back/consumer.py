import pika, sys, os , redis

def main():
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
    channel = connection.channel()

    # Connexion à Redis
    redis_client = redis.StrictRedis(host='localhost', port=6379, db=0)

    channel.queue_declare(queue='calcul')

    def callback(ch, method, properties, body):
        print(f" [x] Received {body}")
        # Décoder le message reçu
        message = body.decode('utf-8')
        message_id, num1, num2, operation = message.split(',')
        num1 = float(num1)
        num2 = float(num2)
        result = None

        # Exécuter l'opération
        if operation == 'addition':
            result = num1 + num2
        elif operation == 'soustraction':
            result = num1 - num2
        elif operation == 'multiplication':
            result = num1 * num2
        elif operation == 'division':
            if num2 != 0:
                result = num1 / num2
            else:
                result = 'Error: Division by zero'
        print(f" operation {operation} result {result}")
        # Enregistrer le résultat dans Redis
        if result is not None:
            redis_client.set(message_id, result)
            print(f" [x] Result: {result}")

    channel.basic_consume(queue='calcul', on_message_callback=callback, auto_ack=True)

    print(' [*] Waiting for messages. To exit press CTRL+C')
    channel.start_consuming()

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('Interrupted')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)