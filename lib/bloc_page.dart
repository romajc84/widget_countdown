import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/timer_bloc.dart';

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
      home: BlocProvider(
        create: (context) => TimerBloc(),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});


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
                BlocBuilder<TimerBloc, TimerState>(
                  builder: (context, state) {
                    return Text(
                      '${(_timerModel.currentTime / 60).floor()}:${(_timerModel.currentTime % 60).toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
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
                      // onPressed: _timerModel.start,
                      onPressed: () => context.read<TimerBloc>().add(TimerStart()),
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
