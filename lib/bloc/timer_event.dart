// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'timer_bloc.dart';

abstract class TimerEvent {}

class TimerStart extends TimerEvent {}

class TimerPause extends TimerEvent {}

class TimerReset extends TimerEvent {}

class TimerTick extends TimerEvent {}

class TimerSetDuration extends TimerEvent {
  int duration;
  TimerSetDuration({
    required this.duration,
  });
}
