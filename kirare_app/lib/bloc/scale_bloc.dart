import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kirare_app/data.dart';
import 'package:kirare_app/models/ScaleModel.dart';
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
      final _state = state as ScaleInitial;
      try {
        if (await _state.recorder.hasPermission()) {
          String musicPath = await getDownloadsPath();
          await _state.recorder.start(
            const RecordConfig(),
            path: "$musicPath/kirare_$createdDate.wav",
          );
          emit(
            ScaleRecording(recorder: _state.recorder, elasedTimeInSeconds: 0),
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
      final _state = state as ScaleRecording;
      print(_state.elasedTimeInSeconds);

      if (_state.elasedTimeInSeconds >= 30) {
        emit(ScaleRecorded());
        try {
          final String? audioPath = await _state.recorder.stop();
          final String kinitResult =
              await sendAudio(audioPath!, _state.elasedTimeInSeconds);
          print("kignit result in bloc, $kinitResult");
          final scaleResult = _getScale(kinitResult);
          print("result in bloc, $scaleResult");

          emit(ScaleResult(result: scaleResult));
        } catch (e) {
          emit(const ScaleError(error: ErrorType.connection));
          await Future.delayed(const Duration(seconds: 2));
          emit(ScaleInitial(recorder: _state.recorder));
        }

        return;
      }

      emit(
        ScaleRecording(
          recorder: _state.recorder,
          elasedTimeInSeconds: _state.elasedTimeInSeconds + 1,
        ),
      );
    }
  }

  _cancelRecording(event, emit) async {
    if (state is ScaleRecording) {
      final _state = state as ScaleRecording;
      await _state.recorder.stop();
      emit(
        ScaleInitial(recorder: _state.recorder),
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
