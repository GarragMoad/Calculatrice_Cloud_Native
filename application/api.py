from flask import Flask, request, jsonify
import redis
import uuid
import json

app = Flask(__name__)

# Connexion au serveur Redis
r = redis.Redis(host='localhost', port=6379, db=0)

# Fonction utilitaire pour stocker et récupérer les résultats en JSON
def store_result(operation_id, result):
    r.set(operation_id, json.dumps(result))

def retrieve_result(operation_id):
    result = r.get(operation_id)
    if result:
        return json.loads(result)
    return None

# Route pour l'addition
@app.route('/api/v1/add', methods=['POST'])
def add():
    data = request.json
    a, b = data.get('a'), data.get('b')
    if a is None or b is None:
        return jsonify({'error': 'Veuillez fournir deux nombres (a et b).'}), 400

    result = a + b
    operation_id = str(uuid.uuid4())
    store_result(operation_id, result)
    return jsonify({'operation_id': operation_id}), 201

# Route pour la soustraction
@app.route('/api/v1/subtract', methods=['POST'])
def subtract():
    data = request.json
    a, b = data.get('a'), data.get('b')
    if a is None or b is None:
        return jsonify({'error': 'Veuillez fournir deux nombres (a et b).'}), 400

    result = a - b
    operation_id = str(uuid.uuid4())
    store_result(operation_id, result)
    return jsonify({'operation_id': operation_id}), 201

# Route pour la multiplication
@app.route('/api/v1/multiply', methods=['POST'])
def multiply():
    data = request.json
    a, b = data.get('a'), data.get('b')
    if a is None or b is None:
        return jsonify({'error': 'Veuillez fournir deux nombres (a et b).'}), 400

    result = a * b
    operation_id = str(uuid.uuid4())
    store_result(operation_id, result)
    return jsonify({'operation_id': operation_id}), 201

# Route pour la division
@app.route('/api/v1/divide', methods=['POST'])
def divide():
    data = request.json
    a, b = data.get('a'), data.get('b')
    if a is None or b is None:
        return jsonify({'error': 'Veuillez fournir deux nombres (a et b).'}), 400

    if b == 0:
        return jsonify({'error': 'Division par zéro impossible.'}), 400

    result = a / b
    operation_id = str(uuid.uuid4())
    store_result(operation_id, result)
    return jsonify({'operation_id': operation_id}), 201

# Route pour récupérer le résultat d'une opération
@app.route('/api/v1/result/<operation_id>', methods=['GET'])
def get_result(operation_id):
    result = retrieve_result(operation_id)
    if result is None:
        return jsonify({'error': 'ID de l\'opération non trouvé.'}), 404

    return jsonify({'result': result}), 200

# Lancement de l'application
if __name__ == '__main__':
    app.run(debug=True)
