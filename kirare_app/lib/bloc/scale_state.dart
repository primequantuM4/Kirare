part of 'scale_bloc.dart';

sealed class ScaleState extends Equatable {
  const ScaleState();

  @override
  List<Object> get props => [];
}

final class ScaleInitial extends ScaleState {
  final AudioRecorder recorder;

  const ScaleInitial({required this.recorder});

  @override
  List<Object> get props => [recorder];
}

final class ScaleRecording extends ScaleState {
  final AudioRecorder recorder;
  final int elasedTimeInSeconds;

  const ScaleRecording(
      {required this.recorder, required this.elasedTimeInSeconds});

  @override
  List<Object> get props => [recorder, elasedTimeInSeconds];
}

final class ScaleRecorded extends ScaleState {
  // This is a loading state
}

final class ScaleResult extends ScaleState {
  final Scale result;

  const ScaleResult({required this.result});

  @override
  List<Object> get props => [result];
}

final class ScaleError extends ScaleState {
  final ErrorType error;

  const ScaleError({required this.error});

  @override
  List<Object> get props => [error];
}

enum Scale {
  tizita,
  ambassel,
  bati,
  anchihoye,
}

enum ErrorType {
  permission,
  recording,
  connection,
  audio,
}
