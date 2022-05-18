part of 'chat_bloc.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object> get props => [];
}

class DataEventStart extends DataEvent {}

class DataEventLoad extends DataEvent {
  final List<List<Post>> data;

  const DataEventLoad(this.data);

  @override
  List<Object> get props => [data];
}

class DataEventFetchMore extends DataEvent {}

//

class GuruEventStart extends DataEvent {}

class GuruEventLoad extends DataEvent {
  final List<List<Post>> data;

  const GuruEventLoad(this.data);

  @override
  List<Object> get props => [data];
}

class GuruEventFetchMore extends DataEvent {}