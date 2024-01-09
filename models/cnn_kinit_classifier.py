import json
import os
import pickle

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

    model.add(
        keras.layers.Conv2D(32, (3, 3), activation="relu", input_shape=input_shape)
    )
    model.add(keras.layers.MaxPool2D((3, 3), strides=(2, 2), padding="same"))
    model.add(keras.layers.BatchNormalization())

    model.add(
        keras.layers.Conv2D(32, (3, 3), activation="relu", input_shape=input_shape)
    )
    model.add(keras.layers.MaxPool2D((3, 3), strides=(2, 2), padding="same"))
    model.add(keras.layers.BatchNormalization())

    model.add(
        keras.layers.Conv2D(32, (2, 2), activation="relu", input_shape=input_shape)
    )
    model.add(keras.layers.MaxPool2D((2, 2), strides=(2, 2), padding="same"))
    model.add(keras.layers.BatchNormalization())

    model.add(
        keras.layers.Conv2D(32, (1, 1), activation="relu", input_shape=input_shape)
    )
    model.add(keras.layers.MaxPool2D((1, 1), strides=(2, 2), padding="same"))
    model.add(keras.layers.BatchNormalization())

    model.add(keras.layers.Flatten())
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

    X_train = X_train[..., np.newaxis]
    X_test = X_test[..., np.newaxis]
    X_validate = X_validate[..., np.newaxis]

    return X_train, X_validate, X_test, Y_train, Y_validate, Y_test


# split the data into train and test
X_train, X_validate, X_test, Y_train, Y_validate, Y_test = train_validate_test_split(
    test_size=0.1, validation_size=0.1
)

print(X_test[0].shape, "X test shape")
input_shape = (X_train.shape[1], X_train.shape[2], X_train.shape[3])

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

with open('win_model_pickle', 'wb') as f:
    pickle.dump(model, f)


model.save("win_model.h5")
