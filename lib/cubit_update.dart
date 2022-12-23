import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppObserver();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  runApp(const MyApp());
}

class AppObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
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
        create: (context) => TimerCubit(),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                BlocBuilder<TimerCubit, TimerState>(
                  builder: (context, state) {
                    return Text(
                      '${(state.currentTime / 60).floor()}:${(state.currentTime % 60).toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<TimerCubit, TimerState>(builder: (context, state) {
                  return Slider(
                      value: (state.currentTime).toDouble(),
                      min: 0,
                      max: 3600,
                      divisions: 60,
                      onChanged: ((value) {
                        BlocProvider.of<TimerCubit>(context).setDuration(value);
                      }));
                }),
                const SizedBox(height: 20),
                BlocBuilder<TimerCubit, TimerState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.running == false &&
                            state.duration == state.currentTime) ...[
                          ElevatedButton(
                            onPressed: () => context.read<TimerCubit>().start(),
                            child: const Text('Start'),
                          ),
                        ],
                        if (state.running == false &&
                            state.duration != state.currentTime) ...[
                          ElevatedButton(
                            onPressed: () => context.read<TimerCubit>().start(),
                            child: const Text('Start'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => context.read<TimerCubit>().reset(),
                            child: const Text('Reset'),
                          ),
                        ],
                        if (state.running == true) ...[
                          ElevatedButton(
                            onPressed: () => context.read<TimerCubit>().pause(),
                            child: const Text('Pause'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => context.read<TimerCubit>().reset(),
                            child: const Text('Reset'),
                          ),
                        ]
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimerState extends Equatable {
  final int time;
  final int duration;
  final int currentTime;
  final bool running;

  const TimerState(this.time, this.duration, this.currentTime, this.running);

  @override
  List<Object> get props => [time, duration, currentTime, running];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'time': time,
      'duration': duration,
      'currentTime': currentTime,
      'running': running,
    };
  }

  factory TimerState.fromMap(Map<String, dynamic> map) {
    return TimerState(
      map['time'] as int,
      map['duration'] as int,
      map['currentTime'] as int,
      map['running'] as bool,
    );
  }
}

class TimerCubit extends HydratedCubit<TimerState> {
  Timer? _timer;

  TimerCubit() : super(const TimerState(1, 1800, 1800, false));

  void setDuration(double newDuration) {
    emit(TimerState(0, newDuration.toInt(), newDuration.toInt(), false));
    reset();
  }

  void start() {
    if (_timer != null && _timer!.isActive) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int time = state.time;
      int duration = state.duration;
      int currentTime = duration - time;
      if (time < duration) {
        time++;
        emit(TimerState(time, duration, currentTime, true));
      } else {
        _timer?.cancel();
        reset();
      }
    });
  }

  void pause() {
    int time = state.time;
    int duration = state.duration;
    int currentTime = duration - time;
    _timer?.cancel();
    emit(TimerState(time, duration, currentTime, false));
  }

  void reset() {
    int time = 1;
    int duration = state.duration;
    int currentTime = state.duration;
    pause();
    emit(TimerState(time, duration, currentTime, false));
  }

  @override
  TimerState? fromJson(Map<String, dynamic> json) {
    return TimerState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TimerState state) {
    return state.toMap();
  }
}
