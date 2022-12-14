import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  int _time = 0;
  Timer? _timer;
  int _duration = 1800;

  int get currentTime => _duration - _time;

  int get duration => _duration;

  TimerBloc() : super(const TimerInitial(0)) {
    on<TimerStart>(_start);
    on<TimerPause>(_pause);
    on<TimerReset>(_reset);
  }

  void setDuration(double newDuration) {
    _duration = newDuration.toInt();
    _time = 0;
    _timer?.cancel();
    // notifyListeners();
  }

  void _start(TimerStart event, Emitter<TimerState> emit) {
    if (_timer != null && _timer!.isActive) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_time < _duration) {
        _time++;
        emit(TimerStarted(event.time));
        // notifyListeners();
      } else {
        _timer?.cancel();
        _time = 0;
      }
    });
  }

  void _pause(TimerPause event, Emitter<TimerState> emit) {
    _timer?.cancel();
  }

  void _reset(TimerReset event, Emitter<TimerState> emit) {
    _time = 0;
    _timer?.cancel();
    emit(const TimerReseted());
    // notifyListeners();
  }
}
