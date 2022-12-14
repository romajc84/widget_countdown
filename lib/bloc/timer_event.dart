part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStart extends TimerEvent {
  final int time;

  const TimerStart(this.time);
}

class TimerPause extends TimerEvent {
  const TimerPause();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}
