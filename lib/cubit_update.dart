// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.read<TimerCubit>().start(),
                      child: const Text('Start'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => context.read<TimerCubit>().pause(),
                      child: const Text('Pause'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => context.read<TimerCubit>().reset(),
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

// STATE
abstract class TimerState {}

class TimerInitial extends TimerState {}

class TimerRunning extends TimerState {}

class TimerPaused extends TimerState {}

// EVENT
abstract class TimerEvent {}

class TimerStart extends TimerEvent {}

class TimerPause extends TimerEvent {}

class TimerReset extends TimerEvent {}

// BLOC
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  
}