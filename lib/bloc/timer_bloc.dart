import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final int duration;
  Timer? timer;

  TimerBloc({this.duration = 1800}) : super(TimerInitial(duration)) {
    on<TimerStart>((event, emit) {});
    on<TimerPause>((event, emit) {});
    on<TimerReset>((event, emit) {});
    on<TimerTick>((event, emit) {});
    on<TimerSetDuration>((event, emit) {});
  }
}
