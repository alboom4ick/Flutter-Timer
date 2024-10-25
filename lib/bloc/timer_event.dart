sealed class TimerEvent {
  const TimerEvent();
}

final class TimerStarted extends TimerEvent {
  TimerStarted({required this.duration});

  final int duration;
}

final class TimerPaused extends TimerEvent {
  const TimerPaused();
}

final class TimerResumed extends TimerEvent {
  const TimerResumed();
}

final class TimerReset extends TimerEvent {
  const TimerReset();
}

final class TickerEvent extends TimerEvent {
  const TickerEvent({required this.duration});

  final int duration;
}
