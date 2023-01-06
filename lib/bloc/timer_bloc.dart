import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc(this._sliderDuration) : super(TimerInitial(1800)) {
    on<TimerStart>(_onTimerStart);
    on<TimerPause>(_onTimerPause);
    on<TimerReset>(_onTimerReset);
    on<TimerTick>(_onTimerTick);
    on<TimerSetDuration>(_onTimerSetDuration);
  }

  late Timer _timer;
  int _sliderDuration;

  void _onTimerStart(TimerStart event, Emitter<TimerState> emit) {
    emit(TimerRunning(state.duration));
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (state.duration < 1) {
          timer.cancel();
          add(TimerReset());
        } else {
          add(TimerTick());
        }
      },
    );
  }

  void _onTimerPause(TimerPause event, Emitter<TimerState> emit) {
    _timer.cancel();
    emit(TimerPaused(state.duration));
  }

  void _onTimerReset(TimerReset event, Emitter<TimerState> emit) {
    _timer.cancel();
    emit(TimerInitial(_sliderDuration));
  }

  void _onTimerTick(TimerTick event, Emitter<TimerState> emit) {
    emit(TimerRunning(state.duration - 1));
  }

  void _onTimerSetDuration(TimerSetDuration event, Emitter<TimerState> emit) {
    _sliderDuration = event.duration;
    emit(TimerInitial(event.duration));
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}
