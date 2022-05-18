
part of 'chat_bloc.dart';

abstract class DataState extends Equatable {
  const DataState();

  @override
  List<Object> get props => [];
}

class DataStateInitial extends DataState {}

class DataStateLoading extends DataState {}

class DataStateEmpty extends DataState {}

class DataStateLoadSuccess extends DataState {
  final List<Post> posts;
  final bool hasMoreData;

  const DataStateLoadSuccess(this.posts, this.hasMoreData);

  @override
  List<Object> get props => [posts];
}


class GuruStateInitial extends DataState {}

class GuruStateLoading extends DataState {}

class GuruStateEmpty extends DataState {}

class GuruStateLoadSuccess extends DataState {
  final List<Post> posts;
  final bool hasMoreData;

  const GuruStateLoadSuccess(this.posts, this.hasMoreData);

  @override
  List<Object> get props => [posts];
}