import json
import math
import os

import librosa
import numpy as np

DATASET_PATH = os.getcwd() + "/../../../EMIR_Dataset_V1"
JSON_PATH = "data.json"

SAMPLE_RATE = 22050
DURATION = 30
SAMPLES_PER_TRACK = SAMPLE_RATE * DURATION


def preprocess_audio(audio_path, duration=30, num_segments=5):
    # Segment the audio and extract MFCC features for each segment
    segments = []
    signal, sr = librosa.load(audio_path, duration=duration, sr=SAMPLE_RATE)
    samples_per_segment = len(signal) // num_segments
    expected_mfcc = math.ceil(samples_per_segment / 512)
    for i in range(num_segments):
        start_sample = samples_per_segment * i
        finish_sample = start_sample + samples_per_segment
        mfcc = librosa.feature.mfcc(
            y=signal[start_sample:finish_sample],
            sr=sr,
            n_fft=2048,
            n_mfcc=13,
            hop_length=512,
        )
        mfcc = mfcc.T

        # Ensure the shape matches the model's input shape
        if len(mfcc) == expected_mfcc:
            segments.append(mfcc.tolist())

    return segments


def preprocess_chunk_audio(audio_path, duration=6):
    signal, sr = librosa.load(audio_path, sr=SAMPLE_RATE, duration=duration)

    mfcc = librosa.feature.mfcc(
        y=signal,
        sr=sr,
        n_fft=2048,
        n_mfcc=13,
        hop_length=512,
    )
    mfcc = mfcc.T
    samples_per_segment = len(signal)
    expected_mfcc = math.ceil(samples_per_segment / 512)

    print(expected_mfcc, "fsomehgdigkcmcnskl")
    print(mfcc.shape)

    if len(mfcc) == expected_mfcc:
        return mfcc.tolist()
    else:
        return None


def save_mfcc(
    dataset_path, json_path, n_mfcc=13, n_fft=2048, hop_length=512, num_segments=5
):
    # dictionary to store the data
    data = {"mapping": [], "mfcc": [], "labels": []}
    num_samples_per_segment = SAMPLES_PER_TRACK // num_segments
    expected_mfcc = math.ceil(num_samples_per_segment / hop_length)

    # loop through all the genres
    for i, (dirpath, dirnames, filenames) in enumerate(os.walk(dataset_path)):
        # save the label of the music
        if dirpath is not dataset_path:
            data["mapping"].append((os.path.basename(dirpath)))
            print("\nProcesssing{}".format(os.path.basename(dirpath)))

        for filename in filenames:
            file_path = os.path.join(dirpath, filename)
            print(file_path)
            signal, sr = librosa.load(file_path, sr=SAMPLE_RATE)

            for segment in range(num_segments):
                start_sample = num_samples_per_segment * segment
                finish_sample = start_sample + num_samples_per_segment

                mfcc = librosa.feature.mfcc(
                    y=signal[start_sample:finish_sample],
                    sr=sr,
                    n_fft=n_fft,
                    n_mfcc=n_mfcc,
                    hop_length=hop_length,
                )

                mfcc = mfcc.T
                if len(mfcc) == expected_mfcc:
                    data["mfcc"].append(mfcc.tolist())
                    data["labels"].append(i - 1)

                    print("{} segment: {}".format(file_path, segment))
    print(data["labels"])

    with open(json_path, "w") as fp:
        json.dump(data, fp, indent=4)
