part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginError extends LoginState {
  final String message;

  LoginError({
    @required this.message
  });
}

class LoginLoaded extends LoginState {
  final SingleUserModel userModel;

  LoginLoaded({
    @required this.userModel
  });
}