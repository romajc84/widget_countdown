part of 'timer_bloc.dart';

abstract class TimerEvent {}

class TimerStart extends TimerEvent {}

class TimerPause extends TimerEvent {}

class TimerReset extends TimerEvent {}

class TimerTick extends TimerEvent {}

class TimerSetDuration extends TimerEvent {
  final double newDuration;

  TimerSetDuration(this.newDuration);
}
