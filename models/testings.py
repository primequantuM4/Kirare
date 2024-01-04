import os
import pickle

import numpy as np

from pre_process_kinit_MLP_classifier import preprocess_audio


def predict(model, X):
    X = np.array(X)
    X = X[..., np.newaxis]

    predictions = model.predict(X)
    print(predictions)
    predicted_index = np.argmax(predictions, axis=1)
    print(predicted_index)


with open("model_pickle", "rb") as f:
    model = pickle.load(f)

music_path = os.getcwd() + "/teddy.mp3"
X = preprocess_audio(music_path)
predict(model, X)
