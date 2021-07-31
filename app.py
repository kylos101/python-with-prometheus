from flask import Flask

app = Flask(__name__)

@app.route("/")
def serve():
    return "Hello, world!"