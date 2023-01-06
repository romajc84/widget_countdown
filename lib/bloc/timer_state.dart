part of 'timer_bloc.dart';

abstract class TimerState {
  final int duration;
  TimerState(this.duration);
}

class TimerInitial extends TimerState {
  TimerInitial(int duration) : super(duration);
}

class TimerRunning extends TimerState {
  TimerRunning(int duration) : super(duration);
}

class TimerPaused extends TimerState {
  TimerPaused(int duration) : super(duration);
}

