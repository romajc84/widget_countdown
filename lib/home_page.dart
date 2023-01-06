import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _timerModel = TimerModel();

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _timerModel,
                  builder: (context, child) {
                    // return Text(
                    //   '${(_timerModel.currentTime / 60).floor()}:${(_timerModel.currentTime % 60).toString().padLeft(2, '0')}',
                    //   style: Theme.of(context).textTheme.headline4,
                    // );
                    return Text(
                      TimerModel._durationString(_timerModel.currentTime),
                      style: Theme.of(context).textTheme.headline4,
                    );
                  },
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                    animation: _timerModel,
                    builder: (context, child) {
                      return Slider(
                        value: (_timerModel.sliderValue).toDouble(),
                        min: 0,
                        max: 3600,
                        divisions: 60,
                        onChanged: _timerModel.setDuration,
                      );
                    }),
                const SizedBox(height: 20),
                AnimatedBuilder(
                    animation: _timerModel,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_timerModel.state == TimerState.initial) ...[
                            ElevatedButton(
                              onPressed: _timerModel.start,
                              child: const Text('Start'),
                            ),
                          ],
                          if (_timerModel.state == TimerState.running) ...[
                            ElevatedButton(
                              onPressed: _timerModel.pause,
                              child: const Text('Pause'),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: _timerModel.reset,
                              child: const Text('Reset'),
                            ),
                          ],
                          if (_timerModel.state == TimerState.paused) ...[
                            ElevatedButton(
                              onPressed: _timerModel.start,
                              child: const Text('Resume'),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: _timerModel.reset,
                              child: const Text('Reset'),
                            ),
                          ],
                          // ElevatedButton(
                          //   onPressed: _timerModel.start,
                          //   child: const Text('Start'),
                          // ),
                          // const SizedBox(width: 10),
                          // ElevatedButton(
                          //   onPressed: _timerModel.pause,
                          //   child: const Text('Pause'),
                          // ),
                          // const SizedBox(width: 10),
                          // ElevatedButton(
                          //   onPressed: _timerModel.reset,
                          //   child: const Text('Reset'),
                          // ),
                        ],
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimerModel extends ChangeNotifier {
  int _time = 0;
  Timer? _timer;
  int _duration = 1800;
  int _sliderValue = 1800;
  TimerState _state = TimerState.initial;

  int get currentTime => _duration - _time;

  int get duration => _duration;

  int get sliderValue => _sliderValue;

  TimerState get state => _state;

  static String _durationString(int duration) {
    final minutes = (duration / 60).floor();
    final seconds = (duration % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void setDuration(double newDuration) {
    _duration = newDuration.toInt();
    _sliderValue = newDuration.toInt();
    reset();
    notifyListeners();
  }

  void start() {
    if (_timer != null && _timer!.isActive) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_time < _duration) {
        _time++;
        _state = TimerState.running;
        notifyListeners();
      } else {
        _timer?.cancel();
        reset();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    _state = TimerState.paused;
  }

  void reset() {
    _time = 0;
    _duration = _sliderValue;
    _state = TimerState.initial;
    _timer?.cancel();
    notifyListeners();
  }
}

enum TimerState { initial, running, paused }
