import yfinance as yf
from flask import Flask
from flask import jsonify
import json
from flask_cors import CORS

app = Flask(__name__)
CORS(app, origins=['http://localhost:3000'])

@app.route("/")
def ping():
    return "<p>pong</p>"


@app.route('/<stock>', methods = ['GET'])
def get(stock):
    msft = yf.Ticker(stock)
    info = msft.info
    info_json = json.dumps(info, indent=4)
    return jsonify(info_json)
