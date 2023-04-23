import yfinance as yf
from flask import Flask
from flask import jsonify
import json

app = Flask(__name__)

@app.route("/")
def ping():
    return "<p>pong</p>"


@app.route("/get", methods = ['GET'])
def get():
    msft = yf.Ticker("MSFT")
    info = msft.info
    info_json = json.dumps(info, indent=4)
    return jsonify(info_json)
