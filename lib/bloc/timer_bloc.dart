import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:timer_advanced/bloc/timer_event.dart';
import 'package:timer_advanced/bloc/timer_state.dart';
import 'package:timer_advanced/ticker.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  StreamSubscription<int>? _tickerSubscribtion;

  final Ticker _ticker;

  static const int timerDuration = 60;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(timerDuration)) {
    on<TimerStarted>(_onStarted);
    on<TickerEvent>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
  }

  @override
  Future<void> close() {
    _tickerSubscribtion?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(
      TimerInitial(event.duration),
    );

    _tickerSubscribtion?.cancel();

    _tickerSubscribtion = _ticker
        .ticker(ticks: event.duration)
        .listen((duration) => add(TickerEvent(duration: duration)));
  }

  void _onTicked(TickerEvent event, Emitter<TimerState> emit) {
    emit(
      event.duration > 0 ? TimerInProgress(event.duration) : const TimerEnded(),
    );
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerInProgress) {
      _tickerSubscribtion?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscribtion?.resume();
      emit(TimerInProgress(state.duration));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscribtion?.cancel();
    emit(const TimerInitial(timerDuration));
  }
}
