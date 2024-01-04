import json
import os

import matplotlib.pyplot as plt
import numpy as np
import tensorflow.keras as keras
from sklearn.model_selection import train_test_split


def load_data(data_path):
    with open(data_path, "r") as fp:
        data = json.load(fp)

    inputs = np.array(data["mfcc"])
    targets = np.array(data["labels"])

    return inputs, targets


def plot_history(history):
    _, ax = plt.subplots(2)

    ax[0].plot(history.history["accuracy"], label="train_accuracy")
    ax[0].plot(history.history["val_accuracy"], label="test_accuracy")
    ax[0].set_ylabel("Accuracy")
    ax[0].legend(loc="lower right")
    ax[0].set_title("Accuracy eval")

    ax[1].plot(history.history["loss"], label="train loss")
    ax[1].plot(history.history["val_loss"], label="test loss")
    ax[1].set_ylabel("Loss")
    ax[1].set_xlabel("Epoch")
    ax[1].legend(loc="upper right")
    ax[1].set_title("Accuracy eval")

    plt.show()


# load data
inputs, targets = load_data(os.getcwd() + "/data.json")

# split the data into train and test
X_train, X_test, Y_train, Y_test = train_test_split(inputs, targets, test_size=0.3)

# build the network architecture
model = keras.Sequential(
    [
        # for input layer
        keras.layers.Flatten(input_shape=(inputs.shape[1], inputs.shape[2])),
        # Hidden layer 1
        keras.layers.Dense(
            512, activation="relu", kernel_regularizer=keras.regularizers.l2(0.001)
        ),
        keras.layers.Dropout(0.3),
        # Hidden layer 2
        keras.layers.Dense(
            256, activation="relu", kernel_regularizer=keras.regularizers.l2(0.001)
        ),
        keras.layers.Dropout(0.3),
        # Hidden layer 3
        keras.layers.Dense(
            64, activation="relu", kernel_regularizer=keras.regularizers.l2(0.001)
        ),
        keras.layers.Dropout(0.3),
        # Output layer
        keras.layers.Dense(4, activation="softmax"),
    ]
)
# compile the network
optimizer = keras.optimizers.Adam(learning_rate=0.0001)
model.compile(
    optimizer=optimizer, loss="sparse_categorical_crossentropy", metrics=["accuracy"]
)

model.summary()
# train the network
history = model.fit(
    X_train, Y_train, validation_data=(X_test, Y_test), epochs=100, batch_size=32
)

plot_history(history)
