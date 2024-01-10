import random
import sys

from flask import Flask, request
from flask_cors import CORS, cross_origin
from lazy_loader import os

sys.path.append("../models")

from testings import load_and_predict, load_and_predict_six

app = Flask(__name__)
CORS(app)


@app.route("/hello", methods=["GET"])
@cross_origin()
def say_hello():
    return "<p>Hello world</p>", 200

@app.route("/upload-audio", methods=["POST"])
@cross_origin()
def upload_audio():
    if "audio" not in request.files:
        return "No audio file uploaded", 400

    print("I have been pinged here")
    audio_file = request.files["audio"]
    print("audio file has been processed", audio_file)
    second_duration = int(request.form["second_duration"])

    print(second_duration)

    if audio_file.filename == "":
        return "No audio file selected", 400

    audio_file.save("audio.wav")
    if second_duration <= 30:
        return load_and_predict_six("audio.wav"), 200

    return load_and_predict("audio.wav"), 200


if __name__ == "__main__":
    app.run(host='10.5.226.224',port=5001, debug=True)
