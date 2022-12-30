import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerModel {
  const TimerModel(this.timeLeft, this.buttonState, this.duration);

  final String timeLeft;
  final ButtonState buttonState;
  final int duration;
}

enum ButtonState {
  initial,
  started,
  paused,
  finished,
}

class TimerNotifier extends StateNotifier<TimerModel> {
  TimerNotifier() : super(_initialState);

  static int _initialDuration = 1800;
  static final _initialState = TimerModel(
    _durationString(_initialDuration),
    ButtonState.initial,
    _initialDuration,
  );

  final Ticker _ticker = Ticker();
  StreamSubscription<int>? _tickerSubscription;

  static String _durationString(int duration) {
    final minutes = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final seconds = (duration % 60).floor().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void changeDuration(int duration) {
    _tickerSubscription?.cancel();
    _initialDuration = duration;
    state = TimerModel(state.timeLeft, ButtonState.initial, duration);
  }

  void start() {
    if (state.buttonState == ButtonState.paused) {
      _restartTimer();
    } else {
      _startTimer();
    }
  }

  void _restartTimer() {
    _tickerSubscription?.resume();
    state = TimerModel(state.timeLeft, ButtonState.started, state.duration);
  }

  void _startTimer() {
    _tickerSubscription?.cancel();

    _tickerSubscription =
        _ticker.tick(ticks: _initialDuration).listen((duration) {
      state = TimerModel(
          _durationString(duration), ButtonState.started, state.duration);
    });

    _tickerSubscription?.onDone(() {
      state = TimerModel(state.timeLeft, ButtonState.finished, state.duration);
    });

    state = TimerModel(
        _durationString(state.duration), ButtonState.started, state.duration);
  }

  void pause() {
    _tickerSubscription?.pause();
    state = TimerModel(state.timeLeft, ButtonState.paused, state.duration);
  }

  void reset() {
    // _tickerSubscription?.cancel();
    changeDuration(state.duration);
    state = TimerModel(state.timeLeft, ButtonState.initial, state.duration);
  }

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }
}

class Ticker {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerModel>(
  (ref) => TimerNotifier(),
);

final _timeLeftProvider = Provider<String>((ref) {
  return ref.watch(timerProvider).timeLeft;
});

final timeLeftProvider = Provider<String>((ref) {
  return ref.watch(_timeLeftProvider);
});

final _initialDuration = Provider<int>((ref) {
  return ref.watch(timerProvider).duration;
});

final initialDuration = Provider<int>((ref) {
  return ref.watch(_initialDuration);
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeLeft = ref.watch(timeLeftProvider);
    final state = ref.watch(timerProvider);
    final duration = ref.watch(initialDuration);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width * 0.33,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[100],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[100],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      timeLeft,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.buttonState == ButtonState.initial) ...[
                          ElevatedButton(
                            onPressed: () =>
                                ref.read(timerProvider.notifier).start(),
                            child: const Text('Start'),
                          ),
                        ],
                        if (state.buttonState == ButtonState.paused) ...[
                          ElevatedButton(
                            onPressed: () =>
                                ref.read(timerProvider.notifier).start(),
                            child: const Text('Start'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () =>
                                ref.read(timerProvider.notifier).reset(),
                            child: const Text('Reset'),
                          ),
                        ],
                        if (state.buttonState == ButtonState.started) ...[
                          ElevatedButton(
                            onPressed: () =>
                                ref.read(timerProvider.notifier).pause(),
                            child: const Text('Pause'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () =>
                                ref.read(timerProvider.notifier).reset(),
                            child: const Text('Reset'),
                          ),
                        ],
                        if (state.buttonState == ButtonState.finished) ...[
                          ElevatedButton(
                            onPressed: () =>
                                ref.read(timerProvider.notifier).reset(),
                            child: const Text('Reset'),
                          ),
                        ]
                      ],
                    )
                  ],
                ),
                RotatedBox(
                  quarterTurns: 3,
                  child: SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 20,
                      thumbColor: Colors.white,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14),
                    ),
                    child: Slider(
                      value: duration.toDouble(),
                      min: 0,
                      max: 3600,
                      divisions: 60,
                      onChanged: (value) => ref
                          .read(timerProvider.notifier)
                          .changeDuration(value.toInt()),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
