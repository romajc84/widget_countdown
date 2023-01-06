import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _duration = 60; // duration in seconds
  bool _isPlaying = false;
  late Timer _timer;

  final TextEditingController _durationController = TextEditingController();

  void _startTimer() {
    setState(() {
      _isPlaying = true;
    });
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (_duration < 1) {
            timer.cancel();
            _isPlaying = false;
          } else {
            _duration--;
          }
        },
      ),
    );
  }

  void _pauseTimer() {
    setState(() {
      _isPlaying = false;
    });
    _timer.cancel();
  }

  void _resetTimer() {
    setState(() {
      _isPlaying = false;
      _duration = 60; // reset to original duration
    });
  }

  void _setDuration() {
    setState(() {
      _duration = int.parse(_durationController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Countdown Timer'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_duration',
              style: const TextStyle(fontSize: 32.0),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: _isPlaying ? null : _startTimer,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: _isPlaying ? _pauseTimer : null,
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: _isPlaying ? null : _resetTimer,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Duration',
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: _setDuration,
                  child: const Text('Set'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
