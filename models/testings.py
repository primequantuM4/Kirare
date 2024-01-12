import os
import pickle

from collections import Counter
from typing import List
import numpy as np
from tensorflow import keras

from pre_process_kinit_MLP_classifier import preprocess_audio, preprocess_chunk_audio


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
    if prediction_freq[max_freq] < 3:
        return mapping[4]
    return mapping[max_freq]


def determine_six_second_kinit(prediction):
    mapping = {
        0: "Tizita",
        1: "Anchihoye",
        2: "Ambassel",
        3: "Bati",
    }
    print(mapping[prediction[0]])
    return mapping[prediction[0]]


def predict(model, X):
    X = np.array(X)
    X = X[..., np.newaxis]

    predictions = model.predict(X)
    predicted_index = np.argmax(predictions, axis=1)
    print(predicted_index)
    return determine_kinit(predicted_index)


def predict_six_seconds(model, X):
    X = np.array(X)
    X = X[np.newaxis, ..., np.newaxis]

    predictions = model.predict(X)
    predicted_index = np.argmax(predictions, axis=1)

    return determine_six_second_kinit(predicted_index)


def load_and_predict(music_path):
    model = keras.models.load_model("../models/win_model.h5")
    X = preprocess_audio(music_path)
    return predict(model, X)


def load_and_predict_six(music_path):
    model = keras.models.load_model("../models/win_model.h5")
    X = preprocess_chunk_audio(music_path)

    return predict_six_seconds(model, X)


def testings_wording():
    print("This code works")


# with open("../models/win_model_pickle", "rb") as f:
#     model = pickle.load(f)
# model = keras.models.load_model("../models/win_model.h5")
# #
# #
# music_path = os.getcwd() + "/kirare_229480.wav"
# X = preprocess_audio(music_path)
# Y = preprocess_chunk_audio(music_path)
# print(predict(model, X))
# print(predict_six_seconds(model, Y))
# #
#
