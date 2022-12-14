part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int time;

  const TimerState(this.time);

  @override
  List<Object> get props => [time];
}

class TimerInitial extends TimerState {
  const TimerInitial(time) : super(time);
}

class TimerStarted extends TimerState {
  const TimerStarted(int time) : super(time);
}

class TimerPaused extends TimerState {
  const TimerPaused(int time) : super(time);
}

class TimerReseted extends TimerState {
  const TimerReseted() : super(0);
}
