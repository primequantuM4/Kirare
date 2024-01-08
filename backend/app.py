import random
import sys

from flask import Flask, request
from lazy_loader import os

sys.path.append("../models")

from testings import load_and_predict, load_and_predict_six

app = Flask(__name__)


@app.route("/upload-audio", methods=["POST"])
def upload_audio():
    if "audio" not in request.files:
        return "No audio file uploaded", 400

    audio_file = request.files["audio"]
    second_duration = int(request.form["second_duration"])

    if audio_file.filename == "":
        return "No audio file selected", 400

    audio_file.save("audio.wav")
    if second_duration <= 30:
        return load_and_predict_six("audio.wav"), 200

    return load_and_predict("audio.wav"), 200


if __name__ == "__main__":
    app.run(debug=True)
