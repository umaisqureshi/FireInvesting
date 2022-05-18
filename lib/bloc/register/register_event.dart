part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class FetchRegisterResults extends RegisterEvent {
 final SingleUserModel singleUserModel;

  FetchRegisterResults({
    @required this.singleUserModel,
  });
}