import re
from flask import Flask, jsonify, request
from flask_cors import CORS
from mts_vis.storage import MTSStorage
import numpy as np

from flask import jsonify

path = None
storage = None
objects = None

app = Flask(__name__)
CORS(app)


@app.route("/loadFromPath", methods=['POST'])
def loadFromPath():
    path = request.get_json()["path"]

    global storage
    storage = MTSStorage(path)
    storage.load()

    global objects
    objects = storage.objects

    return jsonify({'status': 'Done'})

@app.route("/getObjectNames", methods=['POST'])
def get_object_names():
    global storage
    if storage is None:
        return jsonify({'error': 'Storage not loaded'}), 400
    object_names = storage.objects_names()
    return jsonify({'object_names': object_names})

@app.route("/getObjectInfo", methods=['POST'])
def get_object_info():
    global storage
    if storage is None:
        return jsonify({'error': 'Storage not loaded'}), 400
    data = request.get_json()
    name = data.get('name')
    if name not in storage.objects:
        return jsonify({'error': 'Object not found'}), 404
    object_info = storage.get_object_info(name)
    return jsonify({'object_info': object_info})

def initServer(host = "127.0.0.1", port=5000):
    CORS(app)
    app.run(host=host, port=port, debug=False)