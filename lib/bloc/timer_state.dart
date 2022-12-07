part of 'timer_bloc.dart';

abstract class TimerState {
  int get currentTime;

  int get duration;
}

class TimerInitial extends TimerState {
  @override
  final int duration;

  TimerInitial(this.duration);

  @override
  int get currentTime => 0;

  @override
  int get duration => duration;
}

class TimerTicked extends TimerState {
  @override
  final int currentTime;
  @override
  final int duration;

  TimerTicked(this.currentTime, this.duration);

  @override
  int get currentTime => currentTime;

  @override
  int get duration => duration;
}
