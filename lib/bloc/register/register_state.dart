part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterError extends RegisterState {
  final String message;

  RegisterError({
    @required this.message
  });
}

class RegisterLoaded extends RegisterState {
  final SingleUserModel userModel;

  RegisterLoaded({
    @required this.userModel
  });
}