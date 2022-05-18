part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class FetchLoginResults extends LoginEvent {
  final String email;
  final String password;

  FetchLoginResults({
    @required this.email,
    @required this.password
  });
}