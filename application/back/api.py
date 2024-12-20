from flask import Flask, request, jsonify
import pika, redis
import uuid
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
redis_client = redis.StrictRedis(host='redis-service', port=6379, db=0)

def send_message_to_queue(message):
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='rabbitmq-service'))
    channel = connection.channel()
    channel.queue_declare(queue='calcul')
    channel.basic_publish(exchange='', routing_key='calcul', body=message)
    connection.close()

def process_request(data, operation):
    if 'num1' not in data or 'num2' not in data:
        return jsonify({"error": "Please provide num1 and num2"}), 400
    num1 = data['num1']
    num2 = data['num2']
    message_id = str(uuid.uuid4())
    message = f"{message_id},{num1},{num2},{operation}"
    send_message_to_queue(message)
    return jsonify({"status": "Message sent","id": message_id, "message": message})

@app.route('/api/addition', methods=['POST'])
def addition():
    data = request.get_json()
    return process_request(data, 'addition')

@app.route('/api/soustraction', methods=['POST'])
def soustraction():
    data = request.get_json()
    return process_request(data, 'soustraction')

@app.route('/api/multiplication', methods=['POST'])
def multiplication():
    data = request.get_json()
    return process_request(data, 'multiplication')

@app.route('/api/division', methods=['POST'])
def division():
    data = request.get_json()
    return process_request(data, 'division')

@app.route('/api/result/<message_id>', methods=['GET'])
def get_result(message_id):
    result = redis_client.get(message_id)
    if result is not None:
        return jsonify({"result": result.decode('utf-8')})
    return jsonify({"error": "Result not found"}), 404

@app.route('/')
def index():
    return "Welcome to the Flask API!"

if __name__ == '__main__':
    app.run(debug=True , host="0.0.0.0")