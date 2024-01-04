import json
import os

import numpy as np
import tensorflow.keras as keras
from sklearn.model_selection import train_test_split


def load_data(data_path):
    with open(data_path, "r") as fp:
        data = json.load(fp)

    inputs = np.array(data["mfcc"])
    targets = np.array(data["labels"])

    return inputs, targets


def build_model(input_shape):
    model = keras.Sequential()

    model.add(keras.layers.LSTM(64, input_shape=input_shape, return_sequences=True))
    model.add(keras.layers.LSTM(64))

    model.add(keras.layers.Dense(64, activation="relu"))
    model.add(keras.layers.Dropout(0.3))

    model.add(keras.layers.Dense(4, activation="softmax"))

    return model


def train_validate_test_split(test_size, validation_size):
    X, Y = load_data(os.getcwd() + "/data.json")

    # Split the data to train set and test set
    X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=test_size)

    # Split the train data to validation and train
    X_train, X_validate, Y_train, Y_validate = train_test_split(
        X_train, Y_train, test_size=validation_size
    )

    return X_train, X_validate, X_test, Y_train, Y_validate, Y_test


# split the data into train and test
X_train, X_validate, X_test, Y_train, Y_validate, Y_test = train_validate_test_split(
    test_size=0.1, validation_size=0.1
)

input_shape = (X_train.shape[1], X_train.shape[2])
model = build_model(input_shape)


optimizer = keras.optimizers.Adam(learning_rate=0.0001)
model.compile(
    optimizer=optimizer, loss="sparse_categorical_crossentropy", metrics=["accuracy"]
)

model.fit(
    X_train,
    Y_train,
    validation_data=(X_validate, Y_validate),
    batch_size=32,
    epochs=100,
)

test_error, test_accuracy = model.evaluate(X_test, Y_test, verbose=1)
print(test_accuracy)
