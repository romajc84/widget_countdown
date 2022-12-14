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
                    return Text(
                      '${(_timerModel.currentTime / 60).floor()}:${(_timerModel.currentTime % 60).toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  },
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                    animation: _timerModel,
                    builder: (context, child) {
                      return Slider(
                        value: (_timerModel.currentTime).toDouble(),
                        min: 0,
                        max: 3600,
                        divisions: 60,
                        onChanged: _timerModel.setDuration,
                      );
                    }),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _timerModel.start,
                      child: const Text('Start'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _timerModel.pause,
                      child: const Text('Pause'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _timerModel.reset,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
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

  int get currentTime => _duration - _time;

  int get duration => _duration;

  void setDuration(double newDuration) {
    _duration = newDuration.toInt();
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
        notifyListeners();
      } else {
        _timer?.cancel();
        reset();
      }
    });
  }

  void pause() {
    _timer?.cancel();
  }

  void reset() {
    _time = 0;
    pause();
    notifyListeners();
  }
}

// class TimerModel extends ChangeNotifier {
//   int _time = 0;
//   Ticker? _ticker;
//   int _duration = 1800;

//   int get currentTime => _duration - _time;

//   int get duration => _duration;

//   void setDuration(double newDuration) {
//     _duration = newDuration.toInt();
//     reset();
//     notifyListeners();
//   }

//   void start() {
//     if (_ticker != null && _ticker!.isActive) {
//       return;
//     }

//     _ticker = Ticker((Duration elapsed) {
//       if (_time < _duration) {
//         _time++;
//         notifyListeners();
//       } else {
//         _ticker?.stop();
//         reset();
//       }
//     });
//     _ticker?.start();
//   }

//   void pause() {
//     _ticker?.stop();
//   }

//   void reset() {
//     _time = 0;
//     pause();
//     notifyListeners();
//   }
// }