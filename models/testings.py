import os
import pickle
from collections import Counter
from typing import List

import numpy as np

from pre_process_kinit_MLP_classifier import preprocess_audio, preprocess_chunk_audio


def predict(model, X):
    X = np.array(X)
    X = X[..., np.newaxis]

    predictions = model.predict(X)
    predicted_index = np.argmax(predictions, axis=1)
    return predicted_index


def predict_six_seconds(model, X):
    X = np.array(X)
    X = X[np.newaxis, ..., np.newaxis]

    predictions = model.predict(X)
    predicted_index = np.argmax(predictions, axis=1)

    return predicted_index


with open("model_pickle", "rb") as f:
    model = pickle.load(f)


def determine_kinit(music_determination: List[int]):
    mapping = {
        0: "Tizita",
        1: "Anchihoye",
        2: "Ambassel",
        3: "Bati",
        4: "Undecided",
    }
    # get the count of the predictions
    prediction_freq = Counter(music_determination)
    max_freq = max(prediction_freq, key=lambda x: prediction_freq[x])
    print(max_freq, mapping[max_freq], prediction_freq)
    if prediction_freq[max_freq] < 2:
        return mapping[4]
    return mapping[max_freq]


def determine_six_second_kinit(prediction):
    mapping = {
        0: "Tizita",
        1: "Anchihoye",
        2: "Ambassel",
        3: "Bati",
    }
    return mapping[prediction[0]]


music_path = os.getcwd() + "/jumper.wav"
X = preprocess_audio(music_path)
Y = preprocess_chunk_audio(music_path)
print(determine_kinit(predict(model, X)))
print(predict_six_seconds(model, Y))
