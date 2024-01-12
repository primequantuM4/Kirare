part of 'scale_bloc.dart';

sealed class ScaleEvent extends Equatable {
  const ScaleEvent();

  @override
  List<Object> get props => [];
}

class ScaleRecordingStarted extends ScaleEvent {}

class ScaleRecordingCancelled extends ScaleEvent {}

class ScaleRecordingPing extends ScaleEvent {}

class ScaleRefresh extends ScaleEvent {}
