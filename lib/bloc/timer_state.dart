import 'package:equatable/equatable.dart';

sealed class TimerState extends Equatable {
  const TimerState(this.duration);

  final int duration;

  @override
  List<Object> get props => [duration];
}

final class TimerInitial extends TimerState {
  const TimerInitial(super.duration);

  @override
  String toString() => 'TimerInitial: {duration: $duration}';
}

final class TimerInProgress extends TimerState {
  const TimerInProgress(super.duration);

  @override
  String toString() => 'TimeInProgress: {duration: $duration}';
}

final class TimerRunPause extends TimerState {
  const TimerRunPause(super.duration);

  @override
  String toString() => 'TimerPause: {duration: $duration}';
}

final class TimerEnded extends TimerState {
  const TimerEnded() : super(0);
}
