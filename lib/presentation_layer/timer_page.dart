import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_advanced/bloc/timer_bloc.dart';
import 'package:timer_advanced/bloc/timer_event.dart';
import 'package:timer_advanced/bloc/timer_state.dart';
import 'package:timer_advanced/circle_animation/circle_painter.dart';
import 'package:timer_advanced/ticker.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: const Ticker()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer with circle'),
      ),
      body: const Stack(
        children: [
          CircleDisplay(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TimerText(),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              Actions(),
            ],
          ),
        ],
      ),
    );
  }
}

class CircleDisplay extends StatefulWidget {
  const CircleDisplay({super.key});

  @override
  State<CircleDisplay> createState() => _CircleDisplayState();
}

class _CircleDisplayState extends State<CircleDisplay> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final duration = context.select((TimerBloc bloc) => bloc.state.duration);

    const int constDuration = TimerBloc
        .timerDuration; // Receiving the initial duration value set on timer_bloc.dart file

    double position = 0;
    position += duration * (360 / constDuration);

    return SizedBox.fromSize(
      size: Size(width, height),
      child: CustomPaint(
        painter: CirclePainter(position: position),
      ),
    );
  }
}

class TimerText extends StatefulWidget {
  const TimerText({super.key});

  @override
  State<TimerText> createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);

    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');

    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$minutesStr : $secondsStr ',
              style: const TextStyle(
                fontSize: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (event, state) => event.runtimeType != state.runtimeType,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...switch (state) {
                TimerInitial() => [
                    FloatingActionButton(
                        child: const Icon(Icons.play_arrow),
                        onPressed: () => context
                            .read<TimerBloc>()
                            .add(TimerStarted(duration: state.duration))),
                  ],
                TimerInProgress() => [
                    FloatingActionButton(
                      onPressed: () =>
                          context.read<TimerBloc>().add(const TimerReset()),
                      child: const Icon(Icons.replay),
                    ),
                    FloatingActionButton(
                        child: const Icon(Icons.pause),
                        onPressed: () =>
                            context.read<TimerBloc>().add(const TimerPaused()))
                  ],
                TimerRunPause() => [
                    FloatingActionButton(
                      onPressed: () =>
                          context.read<TimerBloc>().add(const TimerReset()),
                      child: const Icon(Icons.replay),
                    ),
                    FloatingActionButton(
                      onPressed: () =>
                          context.read<TimerBloc>().add(const TimerResumed()),
                      child: const Icon(Icons.play_arrow),
                    ),
                  ],
                TimerEnded() => [
                    FloatingActionButton(
                      onPressed: () =>
                          context.read<TimerBloc>().add(const TimerReset()),
                      child: const Icon(Icons.replay),
                    ),
                  ],
              }
            ],
          );
        });
  }
}
