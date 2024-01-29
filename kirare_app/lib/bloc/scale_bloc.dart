import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kirare_app/data/data.dart';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

part 'scale_event.dart';
part 'scale_state.dart';

class ScaleBloc extends Bloc<ScaleEvent, ScaleState> {
  ScaleBloc() : super(ScaleInitial(recorder: AudioRecorder())) {
    on<ScaleRecordingStarted>(_startRecording);
    on<ScaleRecordingPing>(_pingRecording);
    on<ScaleRecordingCancelled>(_cancelRecording);
    on<ScaleRefresh>(_refresh);
  }
  Future<String> getDownloadsPath() async {
    Directory? downloadsDirectory = await getDownloadsDirectory();
    return downloadsDirectory!.path;
  }

  Future<void> _startRecording(event, emit) async {
    final int createdDate = DateTime.now().millisecondsSinceEpoch;

    if (state is ScaleInitial) {
      final currentState = state as ScaleInitial;
      try {
        if (await currentState.recorder.hasPermission()) {
          String musicPath = await getDownloadsPath();
          await currentState.recorder.start(
            const RecordConfig(),
            path: "$musicPath/kirare_$createdDate.wav",
          );
          emit(
            ScaleRecording(
                recorder: currentState.recorder, elasedTimeInSeconds: 0),
          );
        } else {
          emit(const ScaleError(error: ErrorType.permission));
        }
      } catch (e) {
        emit(const ScaleError(error: ErrorType.audio));
      }
    }
  }

  _pingRecording(event, emit) async {
    if (state is ScaleRecording) {
      await Future.delayed(const Duration(seconds: 1));
      final currentState = state as ScaleRecording;

      if (currentState.elasedTimeInSeconds >= 6) {
        emit(ScaleRecorded());
        try {
          final String? audioPath = await currentState.recorder.stop();
          final String kinitResult =
              await sendAudio(audioPath!, currentState.elasedTimeInSeconds);
          final scaleResult = _getScale(kinitResult);

          emit(ScaleResult(result: scaleResult));
        } catch (e) {
          emit(const ScaleError(error: ErrorType.connection));
          await Future.delayed(const Duration(seconds: 2));
          emit(ScaleInitial(recorder: currentState.recorder));
        }

        return;
      }

      emit(
        ScaleRecording(
          recorder: currentState.recorder,
          elasedTimeInSeconds: currentState.elasedTimeInSeconds + 1,
        ),
      );
    }
  }

  _cancelRecording(event, emit) async {
    if (state is ScaleRecording) {
      final currentState = state as ScaleRecording;
      await currentState.recorder.stop();
      emit(
        ScaleInitial(recorder: currentState.recorder),
      );
    }
  }

  _getScale(String scaleResult) {
    Map<String, Scale> scale = {
      "tizita": Scale.tizita,
      "ambassel": Scale.ambassel,
      "bati": Scale.bati,
      "anchihoye": Scale.anchihoye,
    };
    return scale[scaleResult.toLowerCase().trim()];
  }

  _refresh(event, emit) {
    emit(ScaleInitial(recorder: AudioRecorder()));
  }
}
