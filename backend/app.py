from flask import Flask, request

app = Flask(__name__)

@app.route('/upload-audio', methods=['POST'])
def upload_audio():
    if 'audio' not in request.files:
        return 'No audio file uploaded', 400

    audio_file = request.files['audio']
    if audio_file.filename == '':
        return 'No audio file selected', 400

    audio_file.save('audio.wav')
    return 'Audio file successfully uploaded', 200

if __name__ == '__main__':
    app.run(debug=True)







